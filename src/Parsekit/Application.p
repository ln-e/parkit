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


#------------------------------------------------------------------------------
#Make preparations
#------------------------------------------------------------------------------
@initialize[][result]
    $result[]
    ^self.foundRoot[]
###


#------------------------------------------------------------------------------
#Change docroot to containt parsekit.json directory (current or one of parent)
#------------------------------------------------------------------------------
@foundRoot[][result]
    $result[]
    $attempts(10)
    $i(0)
    $rootPostfix[]
    $filepathPrefix[]

#   TODO fix als/fs and loop while not reached root directory
    ^while($i<$attempts){
        ^i.inc[]

        ^if(-f "${filepathPrefix}/parsekit.json"){
            $request:document-root[${request:document-root}$rootPostfix]
            ^break[]
        }{
            $filepathPrefix[/..$filepathPrefix]
            $rootPostfix[${rootPostfix}../]
        }
    }
###


#------------------------------------------------------------------------------
#:param input type Ln-e/Console/Input/InputInterface
#:param output type Ln-e/Console/Output/OutputInterface
#------------------------------------------------------------------------------
@preExecute[input;output][result]
    ^output.writeln[^self.info[]]
###


#------------------------------------------------------------------------------
#Returns information for each call
#
#:result string
#------------------------------------------------------------------------------
@info[][result]
    $result[Parsekit 0.0.1 by Igor Bodnar. Tool for managing project dependencies in parser3.]
#---
