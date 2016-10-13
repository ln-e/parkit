# Created by IntelliJ IDEA.
# User: Игорь
# Date: 23.02.2016
# Time: 0:09
# To change this template use File | Settings | File Templates.

@CLASS
PackageInterface

@OPTIONS
locals

#------------------------------------------------------------------------------
#:constructor
#
#:param name type string
#------------------------------------------------------------------------------
@create[name]
    $self.name[$name]
    $self.type[]
    $self.targetDir[$name]
    $self.sourceType[]
    $self.sourceUrl[]
    $self.sourceReference[]
    $self.distType[]
    $self.distUrl[]
    $self.distReference[]
    $self.version[]
    $self.prettyVersion[]
    $self.releaseDate[]
    $self.stability[]
    $self.requiredPackages[^hash::create[]]
    $self.require[^hash::create[]]
    $self.conflict[^hash::create[]]
    $self.devRequire[^hash::create[]]
    $self.autoload[^hash::create[]]
    $self.devAutoload[^hash::create[]]
    $self.aliases[^hash::create[]]
    $self.mainFileDir[]
    $self.docRoot[]
    $self.repository[]
    $self.uniqueName[]
###


#------------------------------------------------------------------------------
#Forbid acess
#------------------------------------------------------------------------------
@GET_DEFAULT[name]
    ^throw[InterfaceException;PackageInterface.p; Attempt to read field '$name' not defined in interface]
###


#------------------------------------------------------------------------------
#Forbid acess
#------------------------------------------------------------------------------
@SET_DEFAULT[name;value]
    ^throw[InterfaceException;PackageInterface.p; Attempt to set field '$name' not defined in interface]
###


#------------------------------------------------------------------------------
#Returns the pretty version string plus a git or hg commit hash of this package
#:param truncate type bool If the source reference is a sha1 hash, truncate it
#
#:result string
#------------------------------------------------------------------------------
@getFullPrettyVersion[truncate]
    ^throw[Abstract method not implemented]
###
