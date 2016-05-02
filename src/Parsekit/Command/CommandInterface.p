# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 20:21
# To change this template use File | Settings | File Templates.

@CLASS
CommandInterface

@OPTIONS
locals


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@GET_description[]
    ^throw[Abstract method not defined]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    ^throw[Abstract method not defined]
###


#------------------------------------------------------------------------------
#Common command execution start checks. Validate count of arguments.
#
#:param arguments type hash
#:param options type hash
#------------------------------------------------------------------------------
@run[arguments;options]
    $result[]

    $requiredNumber(0)
    $argumentsValue[^hash::create[]]
    $i(0)

    ^self.argumentsConfig.foreach[argumentName;argument]{
        ^if(^argument.isRequired[]){
            $requiredNumber($requiredNumber + 1)
        }
        $argumentsValue.$argumentName[$argument.defaultValue]
        ^if(^arguments._count[]<$i){
            $argumentsValue.$argumentName[^arguments._at($i)]
        }
        $i($i+1)
    }
    ^if(^arguments._count[] < $requiredNumber){
        $result[Wrong count of arguments. Expected $requiredNumber]
#       TODO add description of missing arguments
    }{
        $result[^self.execute[$argumentsValue]]
    }
###


#------------------------------------------------------------------------------
#Abstract method for command execution
#
#:param arguments type hash
#------------------------------------------------------------------------------
@execute[arguments]
    ^throw[Abstract method not defined]
###
