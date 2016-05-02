# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 19:38
# To change this template use File | Settings | File Templates.

@CLASS
Application

@USE
Command/InitCommand.p
Command/InstallCommand.p
Command/RequireCommand.p
Command/SelfupdateCommand.p
Command/UpdateCommand.p
DI/DI.p
Exec/Exec.p
Resolver/Resolver.p
Version/Constraint/Constraint.p
Version/VersionParser.p


@OPTIONS
locals

@auto[]
    $Application:options[^hash::create[]]

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
    $self.commands[
        $.init[^InitCommand::create[]]
        $.require[^RequireCommand::create[]]
        $.install[^InstallCommand::create[]]
        $.update[^UpdateCommand::create[]]
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
        $result[$result^showHelp[]]
    }{
        $params[^self.prepareParams[]]
        $result[$result^self.commands.$commandName.run[$params.arguments;$params.options]]
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
@prepareParams[][result]
    $result[^hash::create[
        $.arguments[^hash::create[]]
        $.options[^hash::create[]]
    ]]
    $i(2)
    ^while($i < ^request:argv._count[]){
        $param[$request:argv.$i]
        ^if(def $param && ^param.pos[--] != 0){
            $ind[^result.arguments._count[]]
            $result.arguments.$ind[$param]
        }(^param.pos[--] == 0){
            $split[^param.match[--([^^\s=]+)=?(\S+)?][i]]
            $result.options.[$split.1][$split.2]
        }
        ^i.inc[]
    }
    $Application:options[$result.options]
###


#------------------------------------------------------------------------------
#Checkes system option
#
#:param name type string
#:param value optional
#------------------------------------------------------------------------------
@static:option[name][result]
    ^if(!def $name){
        ^throw[UnexpectedArgumentException;Application.p; option name shoudl be defined ]
    }{
        $result[$Application:options.$name]
    }
###


#------------------------------------------------------------------------------
#Checkes system option
#
#:param name type string
#------------------------------------------------------------------------------
@static:hasOption[name;value][result]
    ^if(!def $name){
        ^throw[UnexpectedArgumentException;Application.p; option name shoudl be defined ]
    }(def $value){
        $result($Application:options.$name eq $value)
    }{
        $result[^Application:options.contains[$name]]
    }
###
