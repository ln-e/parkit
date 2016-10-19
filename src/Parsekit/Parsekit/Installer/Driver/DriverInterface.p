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
#
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[filesystem]
###


#------------------------------------------------------------------------------
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@supports[url]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#Do all nessessary actions to mount $package to $dir
#
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@mount[dir;package]
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
