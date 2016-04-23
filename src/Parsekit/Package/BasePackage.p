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
    $self.packagesList[^hash::create[]]
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
#Stores the package type, e.g. library, project, etc
#
#:param type type string
#------------------------------------------------------------------------------
@setType[type][result]
    $self.type[$type]
###


#------------------------------------------------------------------------------
#Returns the package type, e.g. library, project, etc
#
#:result string
#------------------------------------------------------------------------------
@getType[][result]
    $result[$self.type]
###


#------------------------------------------------------------------------------
#:param targetDir type string
#------------------------------------------------------------------------------
@setTargetDir[targetDir][result]
    $self.targetDir[$targetDir]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@getTargetDir[][result]
    $result[$self.targetDir]
###


#------------------------------------------------------------------------------
#Stores the repository type of this package, e.g. git, svn
#
#:param sourceType type string
#------------------------------------------------------------------------------
@setSourceType[sourceType][result]
    $self.sourceType[$sourceType]
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
#Stores the repository url of this package
#
#:param sourceUrl type string
#------------------------------------------------------------------------------
@getSourceUrl[sourceUrl][result]
    $self.sourceUrl[$sourceUrl]
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
#Stores the repository reference of this package, e.g. master, 1.0.0 or a commit hash for git
#
#:param sourceReference type string
#------------------------------------------------------------------------------
@setSourceReference[sourceReference][result]
    $self.sourceReference[$sourceReference]
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
#:param version type string
#------------------------------------------------------------------------------
@setVersion[version][result]
    $self.version[$version]
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
#Stores the pretty (i.e. non-normalized) version string of this package
#
#:param prettyVersion type string
#------------------------------------------------------------------------------
@setPrettyVersion[prettyVersion][result]
    $self.prettyVersion[$prettyVersion]
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
#Stores the pretty version string plus a git or hg commit hash of this package
#
#:param fullPrettyVersion type string
#------------------------------------------------------------------------------
@setFullPrettyVersion[fullPrettyVersion][result]
    $self.fullPrettyVersion[$fullPrettyVersion]
###

#------------------------------------------------------------------------------
#Returns the pretty version string plus a git or hg commit hash of this package
#
#:param truncate type boolean If the source reference is a sha1 hash, truncate it
#:result string
#------------------------------------------------------------------------------
@getFullPrettyVersion[truncate]
    $result[$self.fullPrettyVersion]
###


#------------------------------------------------------------------------------
#:param date type date
#------------------------------------------------------------------------------
@setReleaseDate[date][result]
    $self.releaseDate[$date]
###


#------------------------------------------------------------------------------
#:result date
#------------------------------------------------------------------------------
@getReleaseDate[]
    $result[$self.releaseDate]
###


#------------------------------------------------------------------------------
#Stores the stability of this package: one of (dev, alpha, beta, RC, stable)
#
#:param stability type string
#------------------------------------------------------------------------------
@setStability[stability][result]
    $self.stability[$stability]
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
#Stores a hash of links to packages which need to be installed before this package can be installed
#
#:result hash
#------------------------------------------------------------------------------
@setRequires[requires][result]
    $self.requires.[$requires.name][$requires]
###

#------------------------------------------------------------------------------
#Adds to a hash of links to packages which need to be installed before this package can be installed
#
#:param require type PackageInterface
#------------------------------------------------------------------------------
@addRequire[require][result]
    $self.requires.[$require.name][$require]
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
#Stores a set of links to packages which must not be installed at the same time as this package
#
#:param conflicts type hash
#------------------------------------------------------------------------------
@setConflicts[conflicts]
    $self.conflicts[$conflicts]
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
#Adds a set of links to packages which are required to develop this package. These are installed if in dev mode.
#
#:param packageInterface type PackageInterface
#------------------------------------------------------------------------------
@addDevRequire[packageInterface]
    $self.devRequires.[$packageInterface.name][$packageInterface]
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


#------------------------------------------------------------------------------
#:param list type hash
#------------------------------------------------------------------------------
@setPackagesList[list][result]
    $self.packagesList[$list]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@getPackagesList[][result]
    $result[$self.packagesList]
###


#------------------------------------------------------------------------------
#:param packageName type string
#:param constraint type string
#------------------------------------------------------------------------------
@addToPackageList[packageName;constraint][result]
    $result[]
    ^if(!$self.packagesList.$packageName is hash){
        $self.packgesList.$packageName[^hash::create[]]
    }
# Join constraint with space, which means AND
    $newConstraint[$self.packagesList.$packageName $constraint]
    $self.packagesList.$packageName[^newConstraint.trim[]]
###
