# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 2:28
# To change this template use File | Settings | File Templates.

@CLASS
DriverManager

@OPTIONS
locals

@USE
GitDriver.p
ZipDriver.p

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[filesystem]
    $self.filesystem[$filesystem]
    $self.drivers[
        $.git[^GitDriver::create[$filesystem]]
        $.zip[^ZipDriver::create[$filesystem]]
    ]
###


#------------------------------------------------------------------------------
# Attempts to install package in directory
#
#:param dir type string
#:param package type PackageInterface
#:param options type hash
#
#:result bool
#------------------------------------------------------------------------------
@install[dir;package;options][result]
    $result(false)
    $url[^if($options.preferDist){$package.distUrl}{$package.sourceUrl}]
    ^self.drivers.foreach[key;driver]{
        ^if(^driver.supports[$url]){
            $result(^driver.update[$dir;$package])
            ^break[]
        }
    }
###


#------------------------------------------------------------------------------
# Attempts to remove package from directory
#
#:param dir type string
#:param package type string optional
#
#:result bool
#------------------------------------------------------------------------------
@uninstall[dir;package;options]
    $result[^self.filesystem.removeDir[$dir]]
###
