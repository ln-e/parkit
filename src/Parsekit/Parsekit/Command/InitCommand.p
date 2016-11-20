# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
InitCommand

@OPTIONS
locals

@BASE
Ln-e/Console/CommandInterface

#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    ^BASE:create[]
###


#------------------------------------------------------------------------------
#Configure command
#------------------------------------------------------------------------------
@configure[]
    $self.name[init]
    $self.description[initialize new project in current directory]
    ^self.addOption[debug;d;;Enabling debug output]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param input type Ln-e/Console/Input/InputInterface
#:param output type Ln-e/Console/Output/OutputInterface
#------------------------------------------------------------------------------
@execute[input;output][result]
    $jsonFile[^JsonFile::create[/parsekit.json]]

    ^if(^jsonFile.exists[]){
        ^output.writeln[Cound not reinitialize parsekit.json]
    }{
        ^if(^jsonFile.write[^createBaseJson[]]){
            ^output.writeln[parsekit.json has been created]
        }{
            ^output.writeln[Could not create parsekit.json file. Check file permissions.]
        }
    }
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@createBaseJson[]
#   TODO add interactive questions like project name, author etc
    $directory[^Als/Path/Path:basename[$env:PWD]]
    $hash[
        $.name[^if(def $directory){$directory}{New Project}]
        $.type[library]
        $.description[]
        $.require[
            $.parser[>=3.4.3]
        ]
    ]
    $result[$hash]
###
