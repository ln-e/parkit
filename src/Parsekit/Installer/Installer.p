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
#:param packages type hash
#
#:result hash updated packages
#------------------------------------------------------------------------------
@update[lockFile;packages][result]
    ^if(!-d '/vault'){
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

    ^self.install[$packageToUpdate]
    ^self.uninstall[$packageToRemove]

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
        $result[^self.driverManager.install[/vault/$package.name;$package]]
    }
###


#------------------------------------------------------------------------------
#:param packages type hash
#
#:result bool
#------------------------------------------------------------------------------
@uninstall[packages][result]
    ^packages.foreach[key;package]{
        $result[^self.filesystem.removeDir[/vault/$package.name/]]
    }
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createVault[]
    ^self.filesystem.createDir[/vault]
###
