# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 16.04.16
# Time: 17:42
# To change this template use File | Settings | File Templates.

@CLASS
RootPackage

@USE
PackageInterface.p

@OPTIONS
locals

@BASE
BasePackage

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[name]
    ^BASE:create[$name]
    $self.customRepositories[^hash::create[]]
    $self.packageList[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param customRepositories type hash
#------------------------------------------------------------------------------
@setCustomRepositories[customRepositories][result]
    $self.customRepositories[$customRepositories]
###


#------------------------------------------------------------------------------
#:param packageInterface type RepositoryInterface
#------------------------------------------------------------------------------
@addCustomRepository[repository][result]
    $self.customRepositories.[$repository.name][$repository]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@getCustomRepositories[][result]
    $result[$self.customRepositories]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@addToPackageList[packageName;constraint]
###