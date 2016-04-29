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


@auto[]
###

@create[]
    $self.drivers[
        $.git[^GitDriver::create[]]
    ]
###


#------------------------------------------------------------------------------
# Attempts to install package in directory
#
#:param dir type string
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@install[dir;url][result]
    $result(false)
    ^self.drivers.foreach[key;driver]{
        ^if(^driver.supports[$url]){
            $result(^driver.install[$dir;$url])
            ^break[]
        }
    }
###
