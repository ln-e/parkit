# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
SelfupdateCommand

@OPTIONS
locals

@BASE
CommandInterface


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@GET_description[]
    $result[updates parsekit to the latest version]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[^hash::create[]]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_optionsConfig[]
    $result[^hash::create[
        $.0[^CommandOption::create[debug;d;;Enabling debug output]]
    ]]
###


#------------------------------------------------------------------------------
#:param arguments type hash
#:param options type hash
#------------------------------------------------------------------------------
@execute[arguments;options][result]
    $result[self update not yet implemented]
###
