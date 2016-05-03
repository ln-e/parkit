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
#
#:result hash updated packages
#------------------------------------------------------------------------------
@update[lockFile;packages][result]
    ^if(!-d '/$DI:vaultDirName'){
        ^self.createVault[]
    }

    $packageToUpdate[^hash::create[]]
    $packageToRemove[^hash::create[]]
    ^packages.foreach[packageName;package]{
        ^if(^lockFile.addPackage[$package]){
            $packageToUpdate.$packageName[$package]
        }
    }

    ^lockFile.packages.foreach[name;package]{
        ^if(!^packages.contains[$name]){
            $packageToRemove.$name[$package]
        }
    }

    $successInstall[^self.install[$packageToUpdate]]
    $successUninstall[^self.uninstall[$packageToRemove]]
    ^self.dumpClassPath[$packages]

#   Generates text representation. TODO replace by direct write to some outputinterface!
    $info[]
    ^if(^packageToUpdate._count[] == 0 && ^packageToRemove._count[] == 0 ){
        $info[${info}  Nothing to install or update. All package is up to date.^taint[^#0A]]
    }{
        $info[${info}  Dependencies was updated. ^taint[^#0A]]

        ^if(^packageToUpdate._count[] > 0){
            $info[$info ^taint[^#0A]  Updated/installed packages: ^taint[^#0A]]
            ^packageToUpdate.foreach[name;package]{
                $info[$info    - $name^: $package.version^taint[^#0A]]
            }
        }

        ^if(^packageToRemove._count[] > 0){
            $info[${info}  Removed packages:^taint[^#0A]]
            ^packageToRemove.foreach[name;package]{
                ^if(^lockFile.remove[$package]){
                    $info[$info    - $name^: $package.version^taint[^#0A]]
                }
            }
        }
    }

    $result[
        $.updated[$packageToUpdate]
        $.uninstalled[$packageToRemove]
        $.info[$info]
    ]
###


#------------------------------------------------------------------------------
#:param packages type hash
#
#:result bool
#------------------------------------------------------------------------------
@install[packages][result]
    ^packages.foreach[key;package]{
        $result[^self.driverManager.install[/$DI:vaultDirName/$package.name;$package]]
    }
###


#------------------------------------------------------------------------------
#:param packages type hash
#
#:result bool
#------------------------------------------------------------------------------
@uninstall[packages][result]
    ^packages.foreach[key;package]{
        $result[^self.filesystem.removeDir[/$DI:vaultDirName/$package.name/]]
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
^dirs.foreach[i;val]{$val}[^#0a]}]
^$MAIN:CLASS_PATH.join{^$parsekitClassPath}
    ]
    ^string.save[/$DI:vaultDirName/autoload.p]
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createVault[]
    ^self.filesystem.createDir[/$DI:vaultDirName]
###
