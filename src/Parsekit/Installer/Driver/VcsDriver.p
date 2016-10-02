# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 8:58
# To change this template use File | Settings | File Templates.

@CLASS
VcsDriver

@OPTIONS
locals

@BASE
DriverInterface

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[filesystem]
    $self.filesystem[$filesystem]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@mount[dir;package][result]
    ^if(!def $package.sourceReference){
        ^throw[InvalidArgumentException;VcsDriver.p; Git package hasn't source reference. ]
    }
    $url[$package.sourceUrl]

    ^if(^self.filesystem.exists[$dir]){
        ^self.doUpdate[$dir;$package]
    }{
        ^self.filesystem.createDir[$dir]
        $result[^self.doInstall[$dir;$package]]
    }
###
