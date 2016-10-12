# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 10:08
# To change this template use File | Settings | File Templates.

@CLASS
BasePackage

@OPTIONS
locals

@BASE
PackageInterface

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[name]
    ^BASE:create[$name]
###


#------------------------------------------------------------------------------
#Adds to a set of links to packages which must not be installed at the same time as this package
#
#:param package type PackageInterface
#------------------------------------------------------------------------------
@addConflict[package]
    $self.conflict.[$package.name][$package]
###


#------------------------------------------------------------------------------
#Adds to set of packages which are required to develop this package. These are installed if in dev mode.
#
#:param packageName type string
#:param constraint type string
#------------------------------------------------------------------------------
@addDevRequire[packageName;constraint][result]
    $self.devRequire.[$packageName][^constraint.trim[]]
###


#------------------------------------------------------------------------------
#Adds to a hash of packages which need to be installed before this package can be installed
#
#:param packageName type string
#:param constraint type string
#------------------------------------------------------------------------------
@addRequire[packageName;constraint][result]
    $self.require.$packageName[^constraint.trim[]]
###
