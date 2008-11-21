/**
 * Copyright (c) 2008 Sean Clark Hess, Andy Goldstein (Amentra, Inc. - www.amentra.com)

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import com.steelpotato.footerDataGrid.SummaryFooter;

import flash.events.Event;

import mx.collections.ListCollectionView;
import mx.core.UIComponent;

private var _footer:Array = null;
public var footerHeight:int = 0;
public var totalFooterHeight:int = 0;
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
    
    // need to clear out any old footer children that might exist
    if(_footer != null)
    {
        for each (var child:UIComponent in _footer)
        {
             if(this.contains(child))
             {
                 removeChild(child);
             }
        }
    }
    
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
            if(!(child is SummaryFooter))
            {
                throw new Error("All Footers must be SummaryFooter");
            }
            
            var childFooter:SummaryFooter = child as SummaryFooter;
            childFooter.styleName = this;
            childFooter.dataGrid = this;
            addChild(childFooter);
        }
    }
}


override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1):void
{
    if(footer != null && footer.length > 0)
    {
        if(!isNaN(rowHeight))
        {
            footerHeight = rowHeight;
            totalFooterHeight = rowHeight * footer.length;
        }
    }
    
    super.adjustListContent(unscaledWidth, unscaledHeight);

    if(footer != null && footer.length > 0)
    {
        listContent.setActualSize(unscaledWidth, unscaledHeight - totalFooterHeight);
        
        var offset:int = 0;
        for each (var child:UIComponent in footer)
        {
            child.setActualSize(unscaledWidth - 2, footerHeight);
            child.move(listContent.x, unscaledHeight - totalFooterHeight - 1 + offset);
            offset += footerHeight; 
        }
    }
}

override public function invalidateDisplayList():void
{
    super.invalidateDisplayList();
    
    if(footer && footer.length >= 0)
    {
        for each (var child:UIComponent in footer)
        {
            child.invalidateDisplayList();
        }
    }
}