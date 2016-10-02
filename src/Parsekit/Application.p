# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 19:38
# To change this template use File | Settings | File Templates.

@CLASS
Application

@BASE
Ln-e/Console/Application

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#Configures list of available commands
#------------------------------------------------------------------------------
@configureCommands[][result]
    ^self.registerCommand[^DumpClasspathCommand::create[]]
    ^self.registerCommand[^InitCommand::create[]]
    ^self.registerCommand[^InstallCommand::create[]]
    ^self.registerCommand[^RequireCommand::create[]]
    ^self.registerCommand[^UpdateCommand::create[]]
    ^self.registerCommand[^SelfupdateCommand::create[]]
###
