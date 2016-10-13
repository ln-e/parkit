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
#
#:param name type string
#------------------------------------------------------------------------------
@create[name]
    ^BASE:create[$name]
    $self.customRepositories[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param repository type RepositoryInterface
#------------------------------------------------------------------------------
@addCustomRepository[repository][result]
    $self.customRepositories.[$repository.name][$repository]
###


#------------------------------------------------------------------------------
#:param noDev type bool optional
#
#:result hash
#------------------------------------------------------------------------------
@getRequireByEnv[noDev][result]
    $result[^hash::create[$self.require]]

    ^if(!^noDev.bool(false)){
        ^self.devRequire.foreach[packageName;constraint]{
            $result.$packageName[$constraint]
        }
    }
###
