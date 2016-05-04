# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 2:05
# To change this template use File | Settings | File Templates.

@CLASS
DriverInterface

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:param url type string
#:param params type hash
#
#:result bool
#------------------------------------------------------------------------------
@supports[url;*params]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@update[dir;package]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@doInstall[dir;package]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@doUpdate[dir;package]
    ^throw[Abstract method not implemented]
###
