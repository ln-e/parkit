# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:43
# To change this template use File | Settings | File Templates.

@CLASS
RepositoryManager

@OPTIONS
locals

@USE
Repository/ParsekitRepository.p

@auto[]
###

#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    $self.parsekitRepository[^ParsekitRepository::create[]]
###


#------------------------------------------------------------------------------
#:param rootPackage type RootPackage
#------------------------------------------------------------------------------
@getRpositories[rootPackage][result]
# TODO gets extra repositories from rootPackage
    $result[
      $.0[$self.parsekitRepository]
    ]
###
