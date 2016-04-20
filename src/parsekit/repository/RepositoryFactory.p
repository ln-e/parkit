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

@USE
Parsekit/Repository/RepositoryManager.p

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
@static:getManager[]
    $manager[^RepositoryManager:create[]]
    $RepositoryFactory:repositoryManager[$manager]
#    ^manager.addRepositoryClass['parserkit';'ru/parsekit/repository/ParsekitRepository']
    $result[$manager]
###
