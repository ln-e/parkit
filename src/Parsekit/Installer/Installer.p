# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 28.04.16
# Time: 23:30
# To change this template use File | Settings | File Templates.

@CLASS
Installer

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param driverManager type DriverManager
#------------------------------------------------------------------------------
@create[driverManager;filesystem]
    $self.driverManager[$driverManager]
    $self.filesystem[$filesystem]
###


#------------------------------------------------------------------------------
#:param lockFile type LockFile
#:param packages type hash Actual packages
#:param rootPackage type RootPackage
#:param options type hash
#
#:result hash updated packages
#------------------------------------------------------------------------------
@update[lockFile;packages;rootPackage;options][result]
    ^if(!-d '/$DI:vaultDirName'){
        ^self.createVault[]
    }

    $packagesToUpdate[^hash::create[]]
    $packagesToRemove[^hash::create[]]
    ^packages.foreach[packageName;package]{
        ^if(^lockFile.addPackage[$package]){
            $packagesToUpdate.$packageName[$package]
        }
    }

    ^lockFile.packages.foreach[name;package]{
        ^if(!^packages.contains[$name]){
            $packagesToRemove.$name[$package]
        }
    }

    $preferDist($options is hash && ^options.contains[prefer-dist])
    $failedInstall[^self.install[$packagesToUpdate;$.preferDist($preferDist)]]
    $failedUninstall[^if(^failedInstall._count[] == 0){
        ^self.uninstall[$packagesToRemove]
    }{ ^hash::create[] }]
    ^self.dumpClassPath[$packages]

#   Generates text representation. TODO replace by direct write to some outputinterface!
    $info[]
    ^if(^packagesToUpdate._count[] == 0 && ^packagesToRemove._count[] == 0 ){
        $info[${info}  Nothing to install or update. All package is up to date.^#0A]
    }(^failedInstall._count[] == 0 && ^failedUninstall._count[] == 0){
        $info[${info}  Dependencies was updated. ^#0A]

        ^if(^packagesToUpdate._count[] > 0){
            $info[$info ^taint[^#0A]  Updated/installed packages: ^#0A]
            ^packagesToUpdate.foreach[name;package]{
                $info[$info    - $name^: $package.version^#0A]
            }
        }

        ^if(^packagesToRemove._count[] > 0){
            $info[$info  Removed packages:^#0A]
            ^packagesToRemove.foreach[name;package]{
                ^if(^lockFile.remove[$package]){
                    $info[$info    - $name^: $package.version^#0A]
                }
            }
        }
    }{
        $info[${info}ERR!ERR!^#0AERR!ERR!^#0AERR!ERR!^#0A]

        ^if(^failedInstall._count[]){
            $info[$info^#0A  Failed to install or update next packages: ^#0A]

            ^failedInstall.foreach[name;package]{
               $info[$info    - $name^#0A]
            }
        }

        ^if(^failedUninstall._count[]){
            $info[$info^#0A  Failed to remove next packages: ^#0A]

            ^failedUninstall.foreach[name;package]{
               $info[$info    - $name^#0A]
            }
        }
    }

    $result[
        $.updated[$packagesToUpdate]
        $.uninstalled[$packagesToRemove]
        $.failedInstall[$failedInstall]
        $.faileduninstall[$failedUninstall]
        $.info[$info]
    ]
###


#------------------------------------------------------------------------------
#:param packages type hash
#:param options type hash
#
#:result hash of failed packages
#------------------------------------------------------------------------------
@install[packages;options][result]
    $result[^hash::create[]]
    ^packages.foreach[key;package]{
        ^if(!^self.driverManager.mount[/$DI:vaultDirName/$package.targetDir;$package;$options]){
            $result.$key[$package]
            ^break[]
            ^rem[ TODO replace boolean indication by throwing exception ]
        }
        ^if($package.repository.notifyInstalls is junction){
            ^package.repository.notifyInstalls[$package.name]
        }
    }
###


#------------------------------------------------------------------------------
#:param packages type hash
#:param options type hash
#
#:result hash of failed packages
#------------------------------------------------------------------------------
@uninstall[packages;options][result]
    $result[^hash::create[]]
    ^packages.foreach[key;package]{
        ^if(!^self.driverManager.unmount[/$DI:vaultDirName/$package.targetDir;$package;$options]){
            $result.$key[$package]
            ^break[]
            ^rem[ TODO replace boolean indication by throwing exception ]
        }
    }
###


#------------------------------------------------------------------------------
#Dumps class path accroding to packages settings
#
#:param packages type hash
#------------------------------------------------------------------------------
@dumpClassPath[packages][result]
    $dirs[$.0[/$DI:vaultDirName/]]
    ^packages.foreach[name;package]{
        ^if($package.classPath is hash && ^package.classPath._count[] > 0){
            ^package.classPath.foreach[path;type]{
                $dirs.[^dirs._count[]][/$DI:vaultDirName/${name}$path]
                ^if($type eq rdir){
                    $hash[^self.filesystem.subDirs[/$DI:vaultDirName/${name}/$path]]
                    ^hash.foreach[i;dir]{$dirs.[^dirs._count[]][$dir]}
                }
            }
        }{
            $dirs.[^dirs._count[]][/$DI:vaultDirName/${name}$path/]
        }
    }

    $string[^$parsekitClassPath[^^table::create{path
^dirs.foreach[i;val]{$val}[^#0A]}]
^$MAIN:CLASS_PATH.join{^$parsekitClassPath}
    ]
    ^string.save[/$DI:vaultDirName/classpath.p]
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createVault[]
    ^self.filesystem.createDir[/$DI:vaultDirName]
###
