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
@create[driverManager]
    $self.driverManager[$driverManager]
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
    $result[
        $.updated[$packageToUpdate]
        $.uninstalled[$packageToRemove]
    ]
###


#------------------------------------------------------------------------------
#:param packages type hash
#
#:result bool
#------------------------------------------------------------------------------
@install[packages][result]
    ^packages.foreach[key;package]{
        ^self.createDir[/vault/$package.name]
        ^self.driverManager.install[/vault/$package.name;^package.getSourceUrl[]]
        $console:line[Do updates for package $package.name $package.version]
    }
###


#------------------------------------------------------------------------------
#:param packages type hash
#
#:result bool
#------------------------------------------------------------------------------
@uninstall[packages][result]
    ^packages.foreach[key;package]{
        $console:line[Do remove for package $package.name]
    }
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createVault[]
    ^self.createDir[/vault]
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createDir[dir]
    $test[]
    ^test.save[$dir/.vaultkeep]
    ^file:delete[$dir/.vaultkeep;$.keep-empty-dirs(true) $.exception(false)]
###
