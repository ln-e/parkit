# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:51
# To change this template use File | Settings | File Templates.

@CLASS
BaseRepository

@USE
RepositoryInterface.p

@OPTIONS
locals

@BASE
RepositoryInterface

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    $self.packages[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param packages type hash
#------------------------------------------------------------------------------
@load[packages][result]
    $self.packages[^hash::create[]]
    ^packages.foreach[packageKey;packageInterface]{
        ^self:addPackage[packageInterface]
    }
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#------------------------------------------------------------------------------
@addPackage[package][result]
    ^if(!def $self.packages || !$self.packages is hash){
        $self.packages[^hash::create[]]
    }

    $self.packages.[^package:getUniqueName[]][$package]
    ^package:setRepository[$self]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#:result boolean
#------------------------------------------------------------------------------
@hasPackage[package][result]
    ^if(!$package is PackageInterface){
        ^throw[Argument package should be type PackageInterface $package.CLASS_NAME found]
    }

    $result[^self.packages.contains[$package.uniqueName]]
###


#------------------------------------------------------------------------------
#:param name type String
#:param constraint
#:result PackageInterface
#------------------------------------------------------------------------------
@findPackage[name;constraint][result]
    ^self.packages.foreach[uniqueName;packageInterface]{
        ^if($name eq ^packageInterface:getName[]){
#           TODO handle constraints throught some constraint parser
            $result[$packageInterface]
            ^break[]
        }
    }
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@getPackages[][result]
    ^if(!def $self.packages || !$self.packages is hash){
        ^throw[Repository was not configured properly. ^$self.packages not found]
    }

    $result[$self.packages]
###
