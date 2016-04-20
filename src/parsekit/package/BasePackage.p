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
    $self.version[]
    $self.prettyVersion[]
    $self.fullPrettyVersion[]
    $self.releaseDate[]
    $self.stability[]
    $self.requires[^hash::create[]]
    $self.conflicts[^hash::create[]]
    $self.devRequires[^hash::create[]]
    $self.repository[]
    $self.uniqueName[]
###

#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@getName[][result]
    $result[$self.name]
###


#------------------------------------------------------------------------------
#Returns the package type, e.g. library, project, etc
#:result string
#------------------------------------------------------------------------------
@getType[]
    $result[$self.type]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@getTargetDir[][result]
    $result[$self.targetDir]
###


#------------------------------------------------------------------------------
#Returns the repository type of this package, e.g. git, svn
#
#:result string
#------------------------------------------------------------------------------
@getSourceType[][result]
    $result[$self.sourceType]
###


#------------------------------------------------------------------------------
#Returns the repository url of this package
#
#:result string
#------------------------------------------------------------------------------
@getSourceUrl[][result]
    $result[$self.sourceUrl]
###


#------------------------------------------------------------------------------
#Returns the repository reference of this package, e.g. master, 1.0.0 or a commit hash for git
#
#:result string
#------------------------------------------------------------------------------
@getSourceReference[][result]
    $result[$self.sourceReference]
###


#------------------------------------------------------------------------------
#Returns the version of this package
#
#:result string
#------------------------------------------------------------------------------
@getVersion[]
    $result[$self.version]
###


#------------------------------------------------------------------------------
#Returns the pretty (i.e. non-normalized) version string of this package
#
#:result string
#------------------------------------------------------------------------------
@getPrettyVersion[]
    $result[$self.prettyVersion]
###


#------------------------------------------------------------------------------
#Returns the pretty version string plus a git or hg commit hash of this package
#$truncate If the source reference is a sha1 hash, truncate it
#
#:result string
#------------------------------------------------------------------------------
@getFullPrettyVersion[truncate]
    $result[$self.fullPrettyVersion]
###


#------------------------------------------------------------------------------
#:result date
#------------------------------------------------------------------------------
@getReleaseDate[]
    $result[$self.releaseDate]
###


#------------------------------------------------------------------------------
#Returns the stability of this package: one of (dev, alpha, beta, RC, stable)
#
#:result string
#------------------------------------------------------------------------------
@getStability[]
    $result[$self.stability]
###


#------------------------------------------------------------------------------
#Returns a hash of links to packages which need to be installed before this package can be installed
#
#:result hash
#------------------------------------------------------------------------------
@getRequires[]
    $result[$self.requires]
###


#------------------------------------------------------------------------------
#Returns a set of links to packages which must not be installed at the same time as this package
#
#:result hash
#------------------------------------------------------------------------------
@getConflicts[]
    $result[$self.conflicts]
###


#------------------------------------------------------------------------------
#Stores a set of links to packages which are required to develop this package. These are installed if in dev mode.
#
#:param hash type hash
#------------------------------------------------------------------------------
@setDevRequires[hash]
    $self.devRequires[$hash]
###

#------------------------------------------------------------------------------
#Stores a set of links to packages which are required to develop this package. These are installed if in dev mode.
#
#:param packageInterface type PackageInterface
#------------------------------------------------------------------------------
@addDevRequire[packageInterface]
    $self.devRequires.${packageInterface.name}[$packageInterface]
###


#------------------------------------------------------------------------------
#Returns a set of links to packages which are required to develop this package. These are installed if in dev mode.
#
#:result string
#------------------------------------------------------------------------------
@getDevRequires[]
    $result[$self.devRequires]
###


#------------------------------------------------------------------------------
#Stores a reference to the repository that owns the package
#------------------------------------------------------------------------------
@setRepository[repository]
    $self.repository[$repository]
###


#------------------------------------------------------------------------------
#Returns a reference to the repository that owns the package
#
#:result RepositoryInterface
#------------------------------------------------------------------------------
@getRepository[]
    $result[$self.repository]
###


#------------------------------------------------------------------------------
#Stores package unique name, constructed from name and version.
#
#:param uniqueName param string
#------------------------------------------------------------------------------
@setUniqueName[uniqueName]
    $self.uniqueName[$uniqueName]
###


#------------------------------------------------------------------------------
#Returns package unique name, constructed from name and version.
#
#:result string
#------------------------------------------------------------------------------
@getUniqueName[]
    $result[$self.uniqueName]
###
