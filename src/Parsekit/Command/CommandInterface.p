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
#:result hash
#------------------------------------------------------------------------------
@GET_optionsConfig[]
    ^throw[Abstract method not defined]
###


#------------------------------------------------------------------------------
#Common command execution start checks. Validate count of arguments.
#
#:param arguments type hash
#:param options type hash
#------------------------------------------------------------------------------
@run[][result]
    $result[]
    $params[^self.prepareParams[]]
    $arguments[$params.arguments]
    $options[$params.options]

    $requiredNumber(0)
    $argumentsValue[^hash::create[]]
    $optionsValue[^hash::create[]]
    $i(0)

    ^self.argumentsConfig.foreach[argumentName;argument]{
        ^if(^argument.isRequired[]){
            $requiredNumber($requiredNumber + 1)
        }
        $argumentsValue.$argumentName[$argument.default]
        ^if(^arguments._count[]>=$i){
            $argumentsValue.$argumentName[^arguments._at($i)]
        }
        $i($i+1)
    }
    ^self.optionsConfig.foreach[key;option]{
        ^if(^options.contains[$option.name]){
            $optionsValue.[$option.name][$options.[$option.name]]
        }(^options.contains[$option.shortcut]){
            $optionsValue.[$option.name][$options.[$option.shortcut]]
        }
    }
    ^if(^arguments._count[] < $requiredNumber){
        $result[Wrong count of arguments. Expected $requiredNumber]
#       TODO add description of missing arguments
    }{
        $result[^self.execute[$argumentsValue;$options]]
    }
    $Application:options[$optionsValue]
###


#------------------------------------------------------------------------------
#Parses and converts arguments from command line
#
#:result hash
#------------------------------------------------------------------------------
@prepareParams[][result]
    $result[^hash::create[
        $.arguments[^hash::create[]]
        $.options[^hash::create[]]
    ]]
    $i(2)
    ^while($i < ^request:argv._count[]){
        $param[$request:argv.$i]
        ^if(def $param && ^param.pos[-] != 0){
            $ind[^result.arguments._count[]]
            $result.arguments.$ind[$param]
        }(^param.pos[--] == 0){
            $split[^param.match[--([^^\s=]+)=?(\S+)?][i]]
            $result.options.[$split.1][$split.2]
        }(^param.pos[-] == 0){
            $key[^param.mid(1)]
            $value[]
            $next($i+1)
            $nextParam[$request:argv.$next]
            ^if(^nextParam.pos[-] != 0){
                $value[$nextParam]
                ^i.inc[] ^rem[ for skip used param]
            }
            $result.options.$key[$value]
        }
        ^i.inc[]
    }
###


#------------------------------------------------------------------------------
#Abstract method for command execution
#
#:param arguments type hash
#:param options type hash
#------------------------------------------------------------------------------
@execute[arguments;options]
    ^throw[Abstract method not defined]
###
