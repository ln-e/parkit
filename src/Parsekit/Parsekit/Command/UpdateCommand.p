# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
UpdateCommand

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
    $self.name[update]
    $self.description[updates installed dependencies according to require constraints in parsekit.json]
    ^self.addOption[debug;d;;Enabling debug output]
    ^self.addOption[no-dev;](true)[Install without dev dependencies]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param input type Ln-e/Console/Input/InputInterface
#:param output type Ln-e/Console/Output/OutputInterface
#------------------------------------------------------------------------------
@execute[input;output][result]

    $installedLockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]

    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]

    $resolvingResult[^DI:resolver.resolve[^rootPackage.getRequireByEnv[^input.hasOption[no-dev]];$rootPackage.minimumStability](true;^input.hasOption[debug])]


    ^if(!($resolvingResult is ResolvingResult)){
        ^output.writeln[]
        ^output.writeln[Could not update requirements, as it has conflicts. Soon you will see which package cause problem, but now try your luck.]
    }{
        ^if($installedLockFile.empty){
            ^installedLockFile.updateFromPackage[$rootPackage]
        }

        $installResult[^DI:installer.update[$installedLockFile;$resolvingResult.packages;$rootPackage;$input.options]]
        ^output.writeln[$installResult.info]

#       Write second lock to vault dir, to know currently installed version
        ^if(^installedLockFile.save[] && ^installedLockFile.save[/parsekit.lock]){
            ^output.writeln[]
            ^output.writeln[  Lockfile saved.]
        }
    }
###
