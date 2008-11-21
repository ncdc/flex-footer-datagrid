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

package com.steelpotato.footerDataGrid {
    import com.amentra.flex.utils.ExpressionUtils;
    
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.IFactory;

    public class SummaryColumn implements IFooterDataGridColumn {
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
        [Bindable] public var useColumnItemRenderer:Boolean = true;
        
        public var precision:int = 0;
        
        private var _operation:String;

        // dataColumn is the one that feeds the data
        public function set dataColumn(value:Object):void {
            _dataColumn = value;
        }

        public function get dataColumn():Object {
            return (_dataColumn) ? _dataColumn : column;
        }

        private function average(col:Object):Number {
            if (dataProvider) {
                return (sum(col) / dataProvider.length);
            } else {
                return 0;
            }
        }
        
        private function sum(col:Object):Number {
            var total:Number = 0;
            for each (var row:Object in dataProvider) {
                total += ExpressionUtils.resolveExpression(row, col.dataField);
            }
                
            return total;
        }
        
        private function min(col:Object):Number {
            var min:Number;
            for each (var row:Object in dataProvider) {      
                var value:Object = ExpressionUtils.resolveExpression(row, col.dataField);
                if (value != null) {
                    if(Number(value) < min || !min) {
                        min = Number(value);
                    }
                }
            }
                    
            return min;
        }
        
        private function max(col:Object):Number {
            var max:Number;
            for each (var row:Object in dataProvider) {
                var value:Object = ExpressionUtils.resolveExpression(row, col.dataField);
                if(value != null) {
                    if (Number(value) > max || !max) {
                        max = Number(value);
                    }
                }
            }
                    
            return max;
        }
        
        private function count(col:Object):Number {
            var count:Number;
            for each (var row:Object in dataProvider) {
                if (ExpressionUtils.resolveExpression(row, col.dataField)) {
                    count++;
                }
            }
                    
            return count;
        }
        
        public function set operation(value:String):void {
            _operation = value;
            labelFunction = defaultLabelFunction;
        }
        
        private function defaultLabelFunction(col:Object):String {
            var value:Number = 0;
            
            switch (_operation) {
                case SUM:
                    value = sum(col);
                    break;
                case AVG:
                    value = average(col);
                    break;
                case MIN:
                    value = min(col);
                    break;
                case MAX:
                    value = max(col);
                    break;
                case COUNT:
                    value = count(col);
                    break;
            }
            
            var label:String = (value) ? value.toFixed(precision) : '';
            
            return label.replace(/\.00/,'');
        }
        
        public function get dataProvider():Object {
            return footer.dataProvider;
        }
    }
}