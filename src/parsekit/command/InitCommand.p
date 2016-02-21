# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
InitCommand

@USE
Json/JsonFile.p
CommandInterface.p

@OPTIONS
locals

@BASE
CommandInterface

@create[]
###

@GET_description[]
    $result[initialize new project in current directory]
###

@GET_argumentsConfig[]
    $result[^hash::create[]]
###

@execute[arguments]
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

@createBaseJson[]
# TODO add interactive questions like project name, author etc
    $hash[
        $.project[New Project]
        $.require[
            $.parser[>=3.4.3]
        ]
    ]
    $result[$hash]
###