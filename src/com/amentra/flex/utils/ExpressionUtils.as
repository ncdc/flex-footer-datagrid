/**
 * Copyright (c) 2008 Andy Goldstein (Amentra, Inc. - www.amentra.com)

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
package com.amentra.flex.utils
{
    import mx.collections.ArrayCollection;
    
    public class ExpressionUtils
    {
        public function ExpressionUtils()
        {
        }

        public static function resolveExpression(host:Object, expression:String):Object
        {
            if (null == expression || expression == "")
            {
                return null;
            }
            
            if (expression.indexOf(".") == -1 && expression.indexOf("[") == -1)
            {
                if(host.hasOwnProperty(expression))
                {
                    return host[expression];
                }
                return null;
            }
            
            var fields:Array = expression.split(".");
            var endpointData:Object = host;
            var i:uint = 0;
            for each(var field:String in fields)
            {
                i++;
                if(field.indexOf("[") != -1)
                {
                    var indexString:String = field.substring(field.indexOf("[") + 1, field.indexOf("]"));
                    endpointData = endpointData[field.substring(0, field.indexOf("["))];
                    if(Number(indexString) <= (endpointData as ArrayCollection).length - 1)
                    {
                        endpointData = (endpointData as ArrayCollection).getItemAt(Number(indexString));
                    }
                    else
                    {
                        return "";
                    }
                }
                else if(endpointData != null && i <= fields.length)
                {
                    if(endpointData.hasOwnProperty(field))
                    {
                        endpointData = endpointData[field];
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            
            return endpointData;
        }
    }
}