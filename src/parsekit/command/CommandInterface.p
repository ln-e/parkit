# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 20:21
# To change this template use File | Settings | File Templates.

@CLASS
CommandInterface

@OPTIONS
locals

@GET_description[]
    ^throw[Abstract method not defined]
###

@GET_argumentsConfig[]
    ^throw[Abstract method not defined]
###

@run[arguments]
    $result[]

    $requiredNumber(0)
    $argumentsValue[^hash::create[]]
    $i(0)

    ^self.argumentsConfig.foreach[argumentName;argument]{
        ^if(^argument.isRequired[]){
            $requiredNumber($requiredNumber + 1)
        }
        $argumentsValue.$argumentName[^arguments._at($i)]
        $i($i+1)
    }
    ^if(^arguments._count[] < $requiredNumber){
        $result[Wrong count of arguments. Expected $requiredNumber]
#       TODO add description of missing arguments
    }{
        $result[^self.execute[$argumentsValue]]
    }
###

@execute[arguments]
    ^throw[Abstract method not defined]
###