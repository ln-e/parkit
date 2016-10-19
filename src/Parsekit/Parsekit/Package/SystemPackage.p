# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 16.04.16
# Time: 17:42
# To change this template use File | Settings | File Templates.

@CLASS
SystemPackage

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
#:param version type string
#------------------------------------------------------------------------------
@create[name;version]
    ^BASE:create[$name]
    $self.version[$version]
    $self.type[system]
###
