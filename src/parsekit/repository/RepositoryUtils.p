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


#TODO change replace to table and use native method replace?
#:param url type string
#:param replace type hash
@static:maskedUrl[url;replace][result]
    $result[$url]
    ^replace.foreach[name;value]{
        $result[^url.replace[%$name%;$value]]
    }
###
