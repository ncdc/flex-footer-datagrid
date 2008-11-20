import flash.events.Event;
import mx.collections.ListCollectionView;
import mx.core.UIComponent;

private var _footer:Array = [];
public var footerHeight:int = 0;
private var footerDirty:Boolean = false;

override public function set dataProvider(value:Object):void
{
	if (value is ListCollectionView)
		value.addEventListener('collectionChange', onCollectionChange);

	super.dataProvider = value;
}

private function onCollectionChange(event:Event):void
{
	dispatchEvent(new Event('collectionChange'));
}

public function set footer(value:Array):void
{
		footerHeight = 22;
		_footer = value;
		footerDirty = true;
		invalidateProperties();
		invalidateList();
}

public function get footer():Array
{
	return _footer;
}

override protected function commitProperties():void
{
    super.commitProperties();

	if (footerDirty)
	{
		footerDirty = false;
		
		for each (var child:UIComponent in footer)
		{
			if (!(child is SummaryFooter))
				throw new Error("All Footers must be SummaryFooter");
			
			var dg:SummaryFooter = child as SummaryFooter;
			dg.styleName = this;
			dg.dataGrid = this;
			
			addChild(dg);
		}
	}
}


override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1):void
{                
	
	super.adjustListContent(unscaledWidth, unscaledHeight);

	listContent.setActualSize(listContent.width, listContent.height - footerHeight);
	
	//unscaledHeight = unscaledHeight - (footer.length) * (footerHeight);

	

	// listContent.setActualSize(listContent.width, listContent.height - 2*footerHeight);
	
	//var offset:Number = -1;
	                  
	// If it loops through, display them in order!
	for each (var child:UIComponent in footer)
	{
		child.setActualSize(listContent.width, footerHeight);
		child.move(listContent.x, listContent.y + listContent.height + 1); 

		//child.move(listContent.x, unscaledHeight + offset);    
		//offset += footerHeight;
	}
}

override public function invalidateDisplayList():void
{
	super.invalidateDisplayList();
	
	for each (var child:UIComponent in footer)
		child.invalidateDisplayList();
}