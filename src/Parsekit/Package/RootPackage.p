# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 16.04.16
# Time: 17:42
# To change this template use File | Settings | File Templates.

@CLASS
RootPackage

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
###


#------------------------------------------------------------------------------
#:param packageInterface type RepositoryInterface
#------------------------------------------------------------------------------
@addCustomRepository[repository][result]
    $self.customRepositories.[$repository.name][$repository]
###
