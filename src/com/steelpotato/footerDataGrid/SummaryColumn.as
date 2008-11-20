package com.steelpotato.footerDataGrid
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.IFactory;
	import mx.controls.listClasses.IListItemRenderer;

	public class SummaryColumn implements IFooterDataGridColumn
	{
		public static const SUM:String = 'sum';
		public static const MIN:String = 'min';
		public static const MAX:String = 'max';
		public static const AVG:String = 'average';
		public static const COUNT:String = 'count';
		
		private var _dataColumn:Object;
		
		[Bindable] public var footer:SummaryFooter;
		[Bindable] public var labelFunction:Function;
		[Bindable] public var label:String;
		[Bindable] public var itemRenderer:IFactory;
		[Bindable] public var column:Object;
		[Bindable] public var renderer:IListItemRenderer;
		
		public var precision:int = 0;
		
		private var _operation:String;

		// dataColumn is the one that feeds the data
		public function set dataColumn(value:Object):void
		{
			_dataColumn = value;
		}

		public function get dataColumn():Object
		{
			return (_dataColumn) ? _dataColumn : column;
		}

		private function average(col:Object):Number
		{
			if (dataProvider)
				return (sum(col) / dataProvider.length);
				
			else
				return 0;
		}
		
		private function sum(col:Object):Number
		{
			var total:Number = 0;
			for each (var row:Object in dataProvider)
				total += row[col.dataField];
				
			return total;
		}
		
		private function min(col:Object):Number
		{
			var min:Number;
			for each (var row:Object in dataProvider)      
				if (row[col.dataField] < min || !min)
					min = row[col.dataField]
					
			return min;
		}
		
		private function max(col:Object):Number
		{
			var max:Number;
			for each (var row:Object in dataProvider)
				if (row[col.dataField] > max || !max)
					max = row[col.dataField]
					
			return max;
		}
		
		private function count(col:Object):Number
		{
			var count:Number;
			for each (var row:Object in dataProvider)
				if (row[col.dataField])
					count++;
					
			return count;
		}
		
		public function set operation(value:String):void
		{
			_operation = value;
			labelFunction = defaultLabelFunction;
		}
		
		private function defaultLabelFunction(col:Object):String
		{
			var value:Number = 0;
			
			switch (_operation)
			{
				case SUM: value = sum(col); 	break;
				case AVG: value = average(col); break;
				case MIN: value = min(col);		break;
				case MAX: value = max(col);		break;
				case COUNT: value = count(col);	break;
			}
			
			var label:String = (value) ? value.toFixed(precision) : '';
			
			return label.replace(/\.00/,'');
		}
		
		public function get dataProvider():Object
		{
			return footer.dataProvider;
		}

	}

}