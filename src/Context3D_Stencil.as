package
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	[SWF(width="600", height="300")]
	public class Context3D_Stencil extends Sprite
	{
		public const viewWidth:Number = 350;
		public const viewHeight:Number = 240;
		
		private var stage3D:Stage3D;
		private var renderContext:Context3D;
		private var indexList:IndexBuffer3D;
		private var vertexes:VertexBuffer3D;
		
		private const VERTEX_SHADER:String =
			"mov op, va0    \n" +    //copy position to output 
			"mov v0, va1"; //copy color to varying variable v0
		
		private const FRAGMENT_SHADER:String = 
			"mov oc, v0"; //Set the output color to the value interpolated from the three triangle vertices 
		
		private var vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
		private var fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
		private var programPair:Program3D;
		
		public function Context3D_Stencil()
		{            
			stage3D = this.stage.stage3Ds[0];
			stage3D.x = 10;
			stage3D.y = 10;
			
			//Add event listener before requesting the context
			stage3D.addEventListener( Event.CONTEXT3D_CREATE, contextCreated );            
			stage3D.requestContext3D( Context3DRenderMode.AUTO );
			
			//Compile shaders
			vertexAssembly.assemble( Context3DProgramType.VERTEX, VERTEX_SHADER);
			fragmentAssembly.assemble( Context3DProgramType.FRAGMENT, FRAGMENT_SHADER);
			
			non3DSetup();
		}
		
		//Note, context3DCreate event can happen at any time, such as when the hardware resources are taken by another process
		private function contextCreated( event:Event ):void
		{
			renderContext = Stage3D( event.target ).context3D;
			trace( "3D driver: " + renderContext.driverInfo );
			
			renderContext.enableErrorChecking = true; //Can slow rendering - only turn on when developing/testing
			renderContext.configureBackBuffer( viewWidth, viewHeight, 2, true );
			
			//Create vertex index list for the triangles
			var triangles:Vector.<uint> = Vector.<uint>( [  0, 3, 2, 
				0, 1, 3,
				4, 7, 6,
				4, 5, 7,
				8, 9, 10
			] );
			indexList = renderContext.createIndexBuffer( triangles.length );
			indexList.uploadFromVector( triangles, 0, triangles.length );
			
			//Create vertexes
			const dataPerVertex:int = 6;
			var vertexData:Vector.<Number> = Vector.<Number>(
				[
					//x, y, z  r,g,b format 
					-1, 1, 0,  1,0,0,
					1, 1, 0,  0,0,1,
					-1,-1, 0,  0,1,0,
					1,-1, 0,  1,0,1,
					
					-1, 1, 0,  .5,0,0,
					1, 1, 0,  .5,0,0,
					-1,-1, 0,  .5,0,0,
					1,-1, 0,  .5,0,0,
					
					0, .7,.1, 0,0,0,
					-.7,-.7,.1, 0,0,0,
					.7,-.7,.1, 0,0,0
				]);
			vertexes = renderContext.createVertexBuffer( vertexData.length/dataPerVertex, dataPerVertex );
			vertexes.uploadFromVector( vertexData, 0, vertexData.length/dataPerVertex );
			
			//Identify vertex data inputs for vertex program
			renderContext.setVertexBufferAt( 0, vertexes, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
			renderContext.setVertexBufferAt( 1, vertexes, 3, Context3DVertexBufferFormat.FLOAT_3 ); //va1 is color
			
			//Upload programs to render context
			programPair = renderContext.createProgram();
			programPair.upload( vertexAssembly.agalcode, fragmentAssembly.agalcode );
			renderContext.setProgram( programPair );
			render();
		}
		private function render():void
		{
			//Clear, setting stencil to 0
			renderContext.clear( .3, .3, .3, 1, 1, 0 );
			renderContext.setDepthTest(true, Context3DCompareMode.ALWAYS);
//			将印模缓冲区清除为 0。
//			将印模操作设置为当印模测试通过时增加。
//			将印模引用值设置为 0。
//			绘制三角形遮罩。不论何时绘制三角形，印模测试均会通过，这是因为印模缓冲区已经清空为 0 并且引用值为 0。结果，印模缓冲区会增加到 1，在这里将绘制三角形遮罩。
//			更改要保留的印模操作，这样后续绘制操作不会更改印模缓冲区。
//			绘制一个全屏矩形（多色）。由于印模引用值仍为 0，所以印模测试在遮罩区域失败。因此，矩形会绘制到除遮罩区域以外的所有位置。
//			将印模引用值更改为 1。
//			绘制另一个全屏矩形（红色）。现在，印模测试在除遮罩区域以外的所有位置均失败，遮罩区域增加到 1。因此矩形仅在遮罩区域内绘制。
			
			//Draw stencil, incrementing the stencil buffer value
			renderContext.setStencilReferenceValue( 0 );
			renderContext.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, 
				Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE );            
			/*if( state > 0 )*/ renderContext.drawTriangles( indexList, 12, 1 );
			
			//Change stencil action when stencil passes so stencil buffer is not changed
			renderContext.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, 
				Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP );
			
			//Draw quad -- doesn't draw where stencil has already drawn
			/*if( state > 1 )*/ renderContext.drawTriangles( indexList, 0, 2 );
			
			//Change the reference to 1 so this quad only draws into stenciled area
			renderContext.setStencilReferenceValue( 1 );
			/*if( state > 2 )*/ renderContext.drawTriangles( indexList, 6, 2 );
			
//			renderContext.drawTriangles( indexList, 12, 1 );
//			renderContext.drawTriangles( indexList, 0, 2 );
//			renderContext.drawTriangles( indexList, 6, 2 );
			
			//Show the frame
			renderContext.present();
		}
		
		//The rest of the code is for the example UI and timer 
		private function doState( event:TimerEvent ):void
		{
			switch (state)
			{
				case 0:
					description.text = "Draw triangle with stencil action == increment";
					state = 1;
					break;
				case 1:
					description.text = "Draw the first plane where stencil == 0";
					state = 2;
					break;
				case 2:
					description.text = "Draw second plane where stencil == 1";
					state = 3;
					break;
				case 3:
					description.text = "Clear, setting stencil to 0";
					state = 0;
					break;
				
				default:
					description.text = "";
					state = 0;        
			}
			render();
		}
		
		private var state:int = 3;
		private var stateTimer:Timer = new Timer( 2000 );
		private var description:TextField = new TextField();
		
		private function non3DSetup():void
		{
			//Setup timer to animate the stages of drawing the scene
			stateTimer.addEventListener( TimerEvent.TIMER, doState );
			this.stage.addEventListener( MouseEvent.MOUSE_OVER, function(event:Event):void{stateTimer.start()} );
			this.stage.addEventListener( MouseEvent.MOUSE_OUT, function(event:Event):void{stateTimer.stop()} );
			
			description.height = 30;
			description.width = viewWidth;
			this.addChild( description );
			description.y = 250;
			description.defaultTextFormat = new TextFormat( null, 18, 0xff0000 );
			description.text = "Mouse over to view.";
			
			//Allows mouse-over events
			var coverSprite:Sprite = new Sprite();
			coverSprite.graphics.beginFill( 0, .01 )
			coverSprite.graphics.lineTo( stage.stageWidth, 0 );
			coverSprite.graphics.lineTo( stage.stageWidth, stage.stageHeight );
			coverSprite.graphics.lineTo( 0, stage.stageHeight );
			coverSprite.graphics.lineTo( 0, 0 );
			this.addChild( coverSprite );            
		}
	}
}