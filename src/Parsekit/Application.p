# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 19:38
# To change this template use File | Settings | File Templates.

@CLASS
Application

@USE
DI/DI.p
Command/InitCommand.p
Command/RequireCommand.p
Command/SelfupdateCommand.p
Version/VersionParser.p
Version/Constraint/Constraint.p
Resolver/Resolver.p


@OPTIONS
locals

#------------------------------------------------------------------------------
#Dynamic constructor
#------------------------------------------------------------------------------
@create[]
    ^configureCommands[]
###

#------------------------------------------------------------------------------
#Configures list of available commands
#------------------------------------------------------------------------------
@configureCommands[][result]


$parser[^VersionParser::create[]]
^dstop[^parser.parseConstraints[>=1.1.0 as dev <=2.1.0 as asd >=1.2.3  || v1.1.0@dev ||  123 ]]

    $jsonFile[^JsonFile::create[/parsekit.json]]
    $data[^jsonFile.read[]]

    $rootPackage[^DI:packageManager.createRootPackage[$data]]

    $resolver[$DI:resolver]

    ^dstop[^resolver.resolve[$rootPackage]]


    $self.commands[
        $.init[^InitCommand::create[]]
        $.require[^RequireCommand::create[]]
        $.selfupdate[^SelfupdateCommand::create[]]
    ]
###


#------------------------------------------------------------------------------
#Check whatever command exists
#
#:param commandName type string Name of the command to check
#------------------------------------------------------------------------------
@hasCommand[commandName][result]
    $result[^commands.contains[$commandName]]
###


#------------------------------------------------------------------------------
#Starts application
#------------------------------------------------------------------------------
@run[][result]
    $result[^taint[^#0A]]
    $commandName[$request:argv.1]
    ^if(!def $commandName || !^self.hasCommand[$commandName]){
        $result[^showHelp[]]
    }{
        $arguments[^self.prepareArguments[]]
        $result[$result^self.commands.$commandName.run[$arguments]]
    }
###


#------------------------------------------------------------------------------
#Displays list of command.
#------------------------------------------------------------------------------
@showHelp[][result]
    $t[^table::create[nameless]{}]

    ^commands.foreach[key;value]{
        ^t.append[$key	$value.description]
    }
    $result[
Usage:
  command [arguments]

Available commands:
^ConsoleTable:formatTable[$t;  ]]
###


#------------------------------------------------------------------------------
#Parses and converts arguments from command line
#------------------------------------------------------------------------------
@prepareArguments[][result]
    $result[^hash::create[]]
    ^for[i](2;^request:argv._count[]){
        ^if(def $request:argv.$i){
            $result.$i[$request:argv.$i]
        }
    }
###
