# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 19:38
# To change this template use File | Settings | File Templates.

@CLASS
Application

@USE
Command/InitCommand.p
Command/RequireCommand.p
Version/VersionParser.p

@OPTIONS
locals

@create[]
    ^configureCommands[]
###

@configureCommands[]
    $self.commands[
        $.init[^InitCommand::create[]]
        $.require[^RequireCommand::create[]]
    ]
###

@hasCommand[commandName]
    $result[^commands.contains[$commandName]]
###

@run[]
    $result[
]
    $commandName[$request:argv.1]
    ^if(!def $commandName || !^self.hasCommand[$commandName]){
        $result[^showHelp[]]
    }{
        $arguments[^hash::create[]]
        ^for[i](2;^request:argv._count[]){
            ^if(def $request:argv.$i){
                $arguments.$i[$request:argv.$i]
            }
        }
        $result[$result^self.commands.$commandName.run[$arguments]]
    }
###


@showHelp[]
$result[
Usage:
  command [arguments]

Available commands:

^commands.foreach[key;value]{  $key^: $value.description
}[]]
###
