# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 28.04.16
# Time: 23:39
# To change this template use File | Settings | File Templates.

@CLASS
LockFile

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param package type RootPackage
#------------------------------------------------------------------------------
@create[file;package]
    $self.json[^JsonFile::create[$file]]
    ^if(^self.json.exists[]){
        $self.data[^self.json.read[]]
    }(def $package){
        $self.data[$package]
    }{
        $self.empty(true)
        $self.data[^hash::create[]]
        $self.data.name[$data.name]
        $self.data.version[$data.version]
        $self.data.type[$data.type]
        $self.data.stability[$data.stability]
        $self.data.uniqueName[${data.name}$data.version]
        $self.data.packages[^hash::create[]]
        $now[^date::now[]]
        $self.data.created[^now.unix-timestamp[]]
        ^self.detectUpdated[]
    }
###


#------------------------------------------------------------------------------
#:param name type string
#------------------------------------------------------------------------------
@GET_DEFAULT[name][result]
    $result[$self.data.$name]
###


#------------------------------------------------------------------------------
#:param name type string
#:param value
#------------------------------------------------------------------------------
@SET_DEFAULT[name;value][result]
    ^self.detectUpdated[]
    $self.data.$name[$value]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#
#:result bool indicates if package is updated
#------------------------------------------------------------------------------
@addPackage[package][result]
    $result(false)

    ^if(
        (
            $self.data.packages.[$package.name] is PackageInterface &&
            $self.data.packages.[$package.name].version ne $package.version
        )
        ||
        (
            !^self.data.packages.contains[$package.name]
        )
    ){
        $result(true)
    }

    $self.data.packages.[$package.name][$package]
    ^self.detectUpdated[]
###



#------------------------------------------------------------------------------
#:param package type rootPackage
#------------------------------------------------------------------------------
@updateFromPackage[package]
    $self.empty(false)
    $self.data.name[$package.name]
    $self.data.version[$package.version]
    $self.data.type[$package.type]
    $self.data.stability[$package.stability]
    $self.data.uniqueName[${package.name}$package.version]
#    ^self.data.packages.add[$package.requiredPackages]
    ^if(def $package.created){
        $self.data.created[$package.created]
    }
    ^self.detectUpdated[]
###


#------------------------------------------------------------------------------
# Updates lock file on disk
#------------------------------------------------------------------------------
@save[]
    ^self.json.write[
        $.name[$self.data.name]
        $.version[$self.data.version]
        $.type[$self.data.type]
        $.stability[$self.data.stability]
        $.uniqueName[$self.data.uniqueName]
        $.packages[$self.data.packages]
        $.created[$self.data.created]
        $.updated[$self.data.updated]
    ]
###


#------------------------------------------------------------------------------
# Set new update date
#------------------------------------------------------------------------------
@detectUpdated[]
    $now[^date::now[]]
    $self.data.updated[^now.unix-timestamp[]]
###
