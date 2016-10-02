# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 19:38
# To change this template use File | Settings | File Templates.

@CLASS
Application

@OPTIONS
locals

@auto[]
    $Application:options[^hash::create[]]
###


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
        $.dumpclasspath[^DumpClasspathCommand::create[]]
        $.init[^InitCommand::create[]]
        $.install[^InstallCommand::create[]]
        $.require[^RequireCommand::create[]]
        $.selfupdate[^SelfupdateCommand::create[]]
        $.update[^UpdateCommand::create[]]
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
    $result[^#0A]
    $commandName[$request:argv.1]
    ^if(!def $commandName || !^self.hasCommand[$commandName]){
        $result[$result^showHelp[]]
    }{
        $result[$result^self.commands.$commandName.run[]]
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
  command [arguments] [--option[=value]] [-o [value]]

Available commands:
^ConsoleTable:formatTable[$t;  ]]
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
