# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
RequireCommand

@USE
CommandInterface.p
CommandArgument.p
Parsekit/Repository/RepositoryFactory.p
Parsekit/Package/PackageManager.p

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
#:result hash
#------------------------------------------------------------------------------
@GET_description[]
    $result[add dependency to project. NOT IMPELEMENTED YET.]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[
        ^hash::create[
            $.packageName[
                ^CommandArgument::create[packageName;true]
            ]
            $.packageVersion[
                ^CommandArgument::create[packageVersion;false]
            ]
        ]
    ]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#------------------------------------------------------------------------------
@execute[arguments][result]
    ^throw[NotImpelementedException;RequireCommand.p; Command is not impelemented yet. Change parserkit.json manually and run update command instead]
    $result[]
###
