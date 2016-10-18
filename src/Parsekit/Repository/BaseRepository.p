# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:51
# To change this template use File | Settings | File Templates.

@CLASS
BaseRepository

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
#
#:result bool
#------------------------------------------------------------------------------
@hasPackage[packageName][result]
    $result[^self.packages.contains[$packageName]]
###


#------------------------------------------------------------------------------
#:param name type string
#:param constraint type string
#
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
