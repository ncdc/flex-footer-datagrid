/**
 * Copyright (c) 2008 Sean Clark Hess

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
