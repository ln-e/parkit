# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
SelfupdateCommand

@USE
Json/JsonFile.p
CommandInterface.p

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
#:param arguments type hash
#------------------------------------------------------------------------------
@execute[arguments][result]
    $result[self update not yet implemented]
###
