# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
InstallCommand

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
    $self.name[install]
    $self.description[install version locked in parsekit.lock file]
    ^self.addOption[debug;d;;Enabling debug output]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param input type Ln-e/Console/Input/InputInterface
#:param output type Ln-e/Console/Output/OutputInterface
#------------------------------------------------------------------------------
@execute[input;output][result]
    $lockFile[^LockFile::create[/parsekit.lock]]
    $installedLockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]
    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]

    ^if($lockFile.empty){
        ^output.writeln[parsekit.lock file not found! Could not install dependency. May be you mean `parsekit update` command ?]
    }{
        $packages[^DI:packageManager.packagesFromLock[$lockFile]]
        $installResult[^DI:installer.update[$installedLockFile;$packages;$rootPackage;$input.options]]
        ^installedLockFile.save[]
        ^output.writeln[$installResult.info]
    }
###
