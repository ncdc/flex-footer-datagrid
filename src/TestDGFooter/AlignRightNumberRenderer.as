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

package TestDGFooter
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
	import mx.controls.listClasses.BaseListData;
	import mx.events.FlexEvent;
	import mx.formatters.NumberFormatter;
	
	public class AlignRightNumberRenderer extends AdvancedDataGridItemRenderer
	{

		private var formatNumber:NumberFormatter = new NumberFormatter;
		
		public function AlignRightNumberRenderer():void{
			super();
			this.setStyle("textAlign","right");
						
			formatNumber.useThousandsSeparator = true;
			formatNumber.thousandsSeparatorFrom = ",";
			formatNumber.thousandsSeparatorTo = ",";
			
			this.addEventListener(FlexEvent.DATA_CHANGE,handleDataChange);
		}
		
		private function handleDataChange(event:FlexEvent):void{
			if(this.listData){
				this.listData.label = formatNumber.format(this.listData.label);
			}
		}
	}

}