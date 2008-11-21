package com.steelpotato.footerDataGrid
{
	import mx.core.EdgeMetrics;
	import mx.core.IFactory;
	import mx.controls.listClasses.BaseListData;
	import flash.events.IEventDispatcher;
	
	public interface IFooterDataGrid extends IEventDispatcher
	{
		function get horizontalScrollPosition():Number
		function get viewMetrics():EdgeMetrics
		function get columns():Array
		function get itemRenderer():IFactory
		function get rowHeight():Number
		function get dataProvider():Object
		function getStyle(name:String):*
		function createListData(text:String, dataField:String, i:int):BaseListData
	}
}	
