# Created by IntelliJ IDEA.
# User: Игорь
# Date: 23.02.2016
# Time: 0:09
# To change this template use File | Settings | File Templates.

@CLASS
PackageInterface

@OPTIONS
locals

@create[]
###


@getName[]
    ^throw[Abstract method not implemented]
###


@getType[]
    ^throw[Abstract method not implemented]
###


@getTargetDir[]
    ^throw[Abstract method not implemented]
###


#Returns the repository type of this package, e.g. git, svn
@getSourceType[]
    ^throw[Abstract method not implemented]
###


#Returns the repository url of this package
@getSourceUrl[]
    ^throw[Abstract method not implemented]
###


#Returns the repository reference of this package, e.g. master, 1.0.0 or a commit hash for git
@getSourceReference[]
    ^throw[Abstract method not implemented]
###


#Returns the version of this package
@getVersion[]
    ^throw[Abstract method not implemented]
###


#Returns the pretty (i.e. non-normalized) version string of this package
@getPrettyVersion[]
    ^throw[Abstract method not implemented]
###


#Returns the pretty version string plus a git or hg commit hash of this package
#$truncate If the source reference is a sha1 hash, truncate it
@getFullPrettyVersion[truncate]
    ^throw[Abstract method not implemented]
###


@getReleaseDate[]
    ^throw[Abstract method not implemented]
###


#Returns the stability of this package: one of (dev, alpha, beta, RC, stable)
@getStability[]
    ^throw[Abstract method not implemented]
###


#Returns a hash of links to packages which need to be installed before this package can be installed
@getRequires[]
    ^throw[Abstract method not implemented]
###


#Returns a set of links to packages which must not be installed at the same time as this package
@getConflicts[]
    ^throw[Abstract method not implemented]
###


#Returns a set of links to packages which are required to develop this package. These are installed if in dev mode.
@getDevRequires[]
    ^throw[Abstract method not implemented]
###


#Stores a reference to the repository that owns the package
@setRepository[repository]
    ^throw[Abstract method not implemented]
###


#Returns a reference to the repository that owns the package
@getRepository[]
    ^throw[Abstract method not implemented]
###


#Returns package unique name, constructed from name and version.
@getUniqueName[]
    ^throw[Abstract method not implemented]
###
