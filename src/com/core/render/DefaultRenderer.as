package com.core.render
{
	import com.core.entities.NodeBase;

	public class DefaultRenderer extends RendererBase
	{
		public function DefaultRenderer()
		{
			super();
		}
		
		override public function render(rootNode:NodeBase):void
		{
			//TODO:
			var nodes:Vector.<NodeBase> = rootNode.nodes;
			if(!nodes && !nodes.length)return;
			
			for(var i:int = 0; i < nodes.length; i++)
			{
				var node:NodeBase = nodes[i];
				node.render();
			}
		}
	}
}