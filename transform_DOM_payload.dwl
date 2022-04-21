%dw 2.0
import java!java::util::concurrent::atomic::AtomicInteger

var multiChar = "X"
var CELoutValue = AtomicInteger::new(0)
var RateinValue = AtomicInteger::new(0)
var RateoutValue = AtomicInteger::new(0)

output application/xml
fun CELoutincrement() = Java::invoke('java.util.concurrent.atomic.AtomicInteger', 'incrementAndGet()', CELoutValue, {})
fun RATEoutincrement() = Java::invoke('java.util.concurrent.atomic.AtomicInteger', 'incrementAndGet()', CELinValue, {})
fun RATEinincrement() = Java::invoke('java.util.concurrent.atomic.AtomicInteger', 'incrementAndGet()', CELsubValue, {})

fun CELtransformSteps(x, index)=
    x  match {
      case is Object -> x mapObject 
        if  ($$ as String == "DTOSteps")
    	{
                    DTOSteps: CELtransformNewSteps()                
	    }
	    else 
            (($$): CELtransformSteps($, index+1)) 
      else -> $
}
	
fun CELtransformNewSteps()=
    {
		DTOStep @(Order:CELoutincrement(), Name:"Rate Area:", Desc:"NonAuto Layer Premium", Operation:"+", Factor: $.LayerPremNonAuto, Value: $.LayerPremNonAuto ): null
    }


fun RatetransformSteps()=
    {
		DTOStep @(Order:CELoutincrement(), Name:"Rate Area:", Desc:"NonAuto Layer Premium", Operation:"+", Factor: $.LayerPremNonAuto, Value: $.LayerPremNonAuto ): null
		
    }    

fun transformdom(x, index)=
    x match {
      case is Object -> x mapObject 
        if ($$ as String == "DTOCoverage" and $$.@CoverageCd == "CEL")
            { 
                DTOCoverage @(( $$.@)): CELtransformSteps($, index)
            }
		else if ($$ as String == "DTORateArea")
            { 
                DTORateArea @(( $$.@ - "AreaName" , "Description", "FullTermAmt", "FinalPremiumAmt", "WrittenPremiumAmt"), AreaName: $.Desc + " NonAuto", Description: "NonAuto Layer", FullTermAmt:$.LayerPremNonAuto, FinalPremiumAmt: $.LayerPremNonAuto, WrittenPremiumAmt: $.LayerPremNonAuto) : 
				RATEtransformSteps($, index)
            }
        else 
            (($$): transformdom($, index+1)) 
      else -> $
    }
---
transformdom(payload,1)
