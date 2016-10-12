# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 17.04.16
# Time: 11:37
# To change this template use File | Settings | File Templates.

@CLASS
RepositoryUtils

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#TODO should be removed due to new provider naming strategy?
#
#:param url type string
#:param replace type hash
#
#:result string
#------------------------------------------------------------------------------
@static:maskedUrl[url;replace][result]
    $result[$url]
    ^replace.foreach[name;value]{
        $result[^url.replace[%$name%;$value]]
    }
###
