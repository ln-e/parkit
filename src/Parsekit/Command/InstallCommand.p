# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
InstallCommand

@USE
CommandInterface.p
CommandArgument.p
Parsekit/Repository/RepositoryFactory.p
Parsekit/Package/PackageManager.p
Parsekit/Package/LockFile.p

@OPTIONS
locals

@BASE
CommandInterface


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_description[]
    $result[install version locked in parsekit.lock file]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[^hash::create[]]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#:param options type hash
#
#:result string
#------------------------------------------------------------------------------
@execute[arguments;options][result]
    $result[]

    $lockFile[^LockFile::create[/parsekit.lock]]
    $installedLockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]
    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]

    ^if($lockFile.empty){
        $result[parsekit.lock file not found! Could not install dependency. May be you mean `parsekit update` command ?]
    }{
        $packages[^DI:packageManager.packagesFromLock[$lockFile]]
        $installResult[^DI:installer.mount[$installedLockFile;$packages;$rootPackage;$options]]
        ^installedLockFile.save[]
        $result[$installResult.info]
    }
###
