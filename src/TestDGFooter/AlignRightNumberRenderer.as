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