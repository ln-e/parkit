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


#:param options type Hash
@create[options]
  $self.options[$options]
###


@load[packages]
    $self.packages[^hash::create[]]
    ^packages.foreach[packageKey;packageInterface]{
        ^self:addPackage[packageInterface]
    }
###

@addPackage[package]
    $result[]
    if(!def $self.packages || !$self.packages is hash){
        $self.packages[^hash::create[]]
    }

    ${self.packages}.^package:getUniqueName[][$package]
    ^package:setRepository[$self]
###


@hasPackage[package]
    if (!$package is PackageInterface){
        ^throw[Argument package should be type PackageInterface $package.CLASS_NAME found]
    }

    $result[^self.packages.contains[^package.getUniqueName[]]]
###


@findPackage[name;constraint]
    $result[]

    ^self.packages.foreach[uniqueName;packageInterface]{
        if($name eq ^packageInterface:getName[]){
            ^rem{ TODO handle constraints throught some constraint parser }
            $result[$packageInterface]
            ^break[]
        }
    }
###


@getPackages[]
    if(!def $self.packages || !$self.packages is hash){
        ^throw[Repository was not configured properly. ^$self.packages not found]
    }

    $result[$self.packages]
###
