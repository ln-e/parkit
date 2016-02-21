# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:51
# To change this template use File | Settings | File Templates.

@CLASS
ParsekitRepository

@USE
BaseRepository.p

@OPTIONS
locals

@BASE
BaseRepository

@auto[]
###


@create[]
    ^BASE::create[^hash::create[
        $.providerUrl[http://igor.bodnar.ws/p/{package}.json]
    ]]
###
