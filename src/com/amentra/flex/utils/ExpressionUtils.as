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