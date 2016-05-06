# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
InitCommand

@USE
CommandInterface.p
Utils/JsonFile.p

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
    $result[initialize new project in current directory]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[^hash::create[]]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#:param options type hash
#
#:result string
#------------------------------------------------------------------------------
@execute[arguments;options]
    $jsonFile[^JsonFile::create[/parsekit.json]]

    ^if(^jsonFile.exists[]){
        $result[Cound not reinitialize parsekit.json]
    }{
        ^if(^jsonFile.write[^createBaseJson[]]){
            $result[parsekit.json has been created]
        }{
            $result[Could not create parsekit.json file. Check file permissions.]
        }
    }
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@createBaseJson[]
# TODO add interactive questions like project name, author etc
    $hash[
        $.name[New Project]
        $.require[
            $.parser[>=3.4.3]
        ]
    ]
    $result[$hash]
###
