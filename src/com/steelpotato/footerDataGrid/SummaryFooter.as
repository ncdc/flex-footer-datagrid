package com.steelpotato.footerDataGrid
{
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.DisplayObject;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.UIComponent;

import flash.events.Event;

import mx.core.mx_internal;
use namespace mx_internal;

[Style(name="backgroundColor", type="color", inherit="no")]

public class SummaryFooter extends UIComponent
{
	
	protected var overlay:Shape;

	private var _dataGrid:IFooterDataGrid;
	private var _columns:Array;
	private var columnsDirty:Boolean = false;
	
	private var _label:String;
	private var _operation:String
	public var excludeFields:Object = {};		// don't perform the operation on certain fields // 
	
	public var precision:int = 2;
		

	public function SummaryFooter()
	{
		super();      
		setStyle('backgroundColor', 0xF7F7F7); 
	}

	public function get columns():Array
	{
		return _columns;
	}
	
	public function set columns(value:Array):void
	{
		_columns = value;
		columnsDirty = true;
		invalidateProperties();
	}
	
	public function set operation(value:String):void
	{
		_operation = value;
		columnsDirty = true;
		invalidateProperties();
	}
	
	public function set label(value:String):void
	{
		_label = value;
		columnsDirty = true;
		invalidateProperties();
	}
	
	internal function get dataProvider():Object
	{
		return dataGrid.dataProvider;
	}
	
	public function set dataGrid(value:IFooterDataGrid):void
	{
		_dataGrid = value;
		_dataGrid.addEventListener('collectionChange', onCollectionChange);
	}
	
	public function get dataGrid():IFooterDataGrid
	{
		return _dataGrid;
	}
	
	private function onCollectionChange(event:Event):void
	{
		for (var key:String in columns)
			if (columns[key] is IFooterDataGridColumn)			// columns is originally set to the parent's columns.  I need to fix that
				createListData(columns[key], new int(key));
	}
	
	private function createListData(fdgc:IFooterDataGridColumn, i:Number):void
	{
		if (fdgc.renderer is IDropInListItemRenderer)
		{
			var text:String = (fdgc.labelFunction != null) ? fdgc.labelFunction(fdgc.dataColumn) : fdgc.label;
			(fdgc.renderer as IDropInListItemRenderer).listData = dataGrid.createListData(text, fdgc.dataColumn.dataField, i);
		}
	}
	
	override protected function commitProperties():void
	{
		if ( columnsDirty && _label && _operation && dataGrid && dataGrid.columns && dataGrid.columns.length > 0)
			_columns = generateColumns();
			
		if ( columnsDirty && _columns)
		{
			columnsDirty = false;
			removeAllColumns();
			addNewColumns();
		}
	}
	
	import mx.utils.ObjectUtil;
	private function generateColumns():Array
	{
		var columns:Array = [];
		
		var labelColumn:SummaryColumn = new SummaryColumn();
			labelColumn.label = _label;
			
		columns.push(labelColumn);
		
		for (var index:int = 1; index < dataGrid.columns.length; index++)
		{
			var dataColumn:SummaryColumn = new SummaryColumn();
			
			if (excludeFields[dataGrid.columns[index].dataField])
				dataColumn.label = '';
				
			else
			{
				dataColumn.operation = _operation;
				dataColumn.precision = precision;
			}
			
			columns.push(dataColumn);
		}
		
		return columns;
	}
	
	private function removeAllColumns():void
	{
		while (numChildren > 1)
			removeChildAt(1);
	}
	
	private function addNewColumns():void
	{
		// Pass References // 
		for each (var column:Object in columns)
		{
			if (column is IFooterDataGridColumn)
				(column as IFooterDataGridColumn).footer = this;
		}
		
		for (var key:String in columns)
		{
			var i:int = new int(key);
			var col:Object = columns[i];

			if (col is IFooterDataGridColumn)
			{
				var fdgc:IFooterDataGridColumn = col as IFooterDataGridColumn;

				if (!fdgc.column)
					fdgc.column = dataGrid.columns[i];
					
				// fdgc.owner = fdgc.column.owner;

				// Create the item renderer if specified or from the datagrid
				var renderer:IListItemRenderer = (fdgc.column.itemRenderer) ? 
					fdgc.column.itemRenderer.newInstance() : 
					dataGrid.itemRenderer.newInstance();
				
				// I believe this makes it read from this for its styles?
				renderer.styleName = fdgc.column;
				
				fdgc.renderer = renderer;	// save it for later

				createListData(fdgc, i);

				// Set the data to the real column 
				renderer.data = fdgc.dataColumn;
				addChild(DisplayObject(renderer));
			}

			else
			{
				error("All Columns Must be IFooterDataGridColumns " + col + " :: " + i);
			}
		}
	}
	
	private function error(message:String):void
	{
		// trace(message);
		throw new Error(message);
	}
	
	/**
	 *  create the actual border here
	 */
	override protected function createChildren():void
	{
		overlay = new Shape();
		addChild(overlay);
	}

	/**
	 *	lay it out
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		overlay.graphics.clear();      

		// draw background //      
		var bgcolor:uint = getStyle('backgroundColor');
		overlay.graphics.lineStyle(0,0x0, 0);
		overlay.graphics.beginFill(bgcolor);
		overlay.graphics.drawRect(0,0,w,h);
		
		// Initialize line settings
		var lineCol:uint = dataGrid.getStyle("verticalGridLineColor");
        var vlines:Boolean = dataGrid.getStyle("verticalGridLines");
		overlay.graphics.lineStyle(1, lineCol);
		
		var xx:Number = 0;	// changes for each renderer
		var yy:Number = 0;	// stays the same
		
		
		for each (var fdgc:IFooterDataGridColumn in columns)
		{
			if (!fdgc.column)
			{
				error("SummaryFooter Error: Missing column handle");
				continue; 
			}
				
			var columnWidth:Number = fdgc.column.width;

			// Resize the renderer
			if (!fdgc.renderer)
			{
				error("SummaryFooter Error: Missing column renderer");
				continue;
			}
			
			fdgc.renderer.setActualSize(columnWidth - 1, dataGrid.rowHeight);
			fdgc.renderer.x = xx;
			fdgc.renderer.y = yy;
			if(fdgc.column.colNum < dataGrid.horizontalScrollPosition){
				fdgc.renderer.visible = false;
			}else{
				fdgc.renderer.visible = fdgc.column.visible;
			}
			
			
			if (fdgc.renderer.visible)
			{
				// Draw vLines
				if (vlines)
				{
					overlay.graphics.moveTo(xx + columnWidth, yy);
					overlay.graphics.lineTo(xx + columnWidth, h);
				}

				// Update xx
				xx += columnWidth;
			}
		}
	
		// Horizontal Grid Lines
        lineCol = dataGrid.getStyle("horizontalGridLineColor");
        if (dataGrid.getStyle("horizontalGridLines"))
		{
			overlay.graphics.lineStyle(1, lineCol);
			overlay.graphics.moveTo(0, yy);
			overlay.graphics.lineTo(w, yy);
		}

		// draw separator at top of footer
		lineCol = dataGrid.getStyle("borderColor");
		overlay.graphics.lineStyle(1, lineCol);
		overlay.graphics.moveTo(0, 0);
		overlay.graphics.lineTo(w, 0);   
		
		// draw separator at bottom of footer
		lineCol = dataGrid.getStyle("borderColor");
		overlay.graphics.lineStyle(1, lineCol);
		overlay.graphics.moveTo(0, dataGrid.rowHeight);
		overlay.graphics.lineTo(w, dataGrid.rowHeight);  

	}

}

}