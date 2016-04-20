# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:43
# To change this template use File | Settings | File Templates.

@CLASS
RepositoryFactory

@OPTIONS
locals
static

@auto[]
###

#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:result RepositoryManager
#------------------------------------------------------------------------------
@createManager[]
    $repositoryManager[^RepositoryManager:create[]]
    ^repositoryManager:addRepositoryClass['parserkit']['ru/parsekit/repository/ParsekitRepository']
    $result[$repositoryManager]
###
