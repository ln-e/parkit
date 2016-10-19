# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 23.02.2016
# Time: 0:08
# To change this template use File | Settings | File Templates.

@CLASS
RepositoryInterface

@OPTIONS
locals

#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:param packageName type string
#
#:result boolean
#------------------------------------------------------------------------------
@hasPackage[packageName]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:param name type string
#:param constraint
#
#:result PackageInterface
#------------------------------------------------------------------------------
@findPackage[name;constraint]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@getPackages[]
    ^throw[Abstract method not implemented]
###
