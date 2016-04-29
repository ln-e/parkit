# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 2:03
# To change this template use File | Settings | File Templates.

@CLASS
GitDriver

@OPTIONS
locals

@USE
DriverInterface.p

@BASE
DriverInterface


@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@supports[url]
    $result(false)
    ^if(-d url){
        ^rem[ TODO handle local url]
    }{
        ^if(^url.match[(^^git://|\.git^$|git(?:olite)?@|//git\.|//github.com/)][in]>0){
            $result(true)
        }
    }
###


#------------------------------------------------------------------------------
#:param dir type string
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@install[dir;url]
    $console:line[ do smth to install $url in $dir ]
###
