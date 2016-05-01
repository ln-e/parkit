# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 10:08
# To change this template use File | Settings | File Templates.

@CLASS
BasePackage

@USE
PackageInterface.p

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
    $self.name[$name]
    $self.type[]
    $self.targetDir[]
    $self.sourceType[]
    $self.sourceUrl[]
    $self.sourceReference[]
    $self.preferDist(false)
    $self.distType[]
    $self.distUrl[]
    $self.distReference[]
    $self.version[]
    $self.prettyVersion[]
    $self.releaseDate[]
    $self.stability[]
    $self.requiredPackages[^hash::create[]]
    $self.requires[^hash::create[]]
    $self.conflicts[^hash::create[]]
    $self.devRequires[^hash::create[]]
    $self.repository[]
    $self.uniqueName[]
###


#------------------------------------------------------------------------------
#Adds to a set of links to packages which must not be installed at the same time as this package
#
#:param package type PackageInterface
#------------------------------------------------------------------------------
@addConflict[package]
    $self.conflicts.[$package.name][$package]
###


#------------------------------------------------------------------------------
#Adds to set of packages which are required to develop this package. These are installed if in dev mode.
#
#:param packageName type string
#:param constraint type string
#------------------------------------------------------------------------------
@addDevRequire[packageName;constraint][result]
    $self.devRequires.[$packageName][^constraint.trim[]]
###


#------------------------------------------------------------------------------
#Adds to a hash of packages which need to be installed before this package can be installed
#
#:param packageName type string
#:param constraint type string
#------------------------------------------------------------------------------
@addRequire[packageName;constraint][result]
    $self.requires.$packageName[^constraint.trim[]]
###
