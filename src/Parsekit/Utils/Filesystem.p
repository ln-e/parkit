# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 9:03
# To change this template use File | Settings | File Templates.

@CLASS
Filesystem

@OPTIONS
locals

@auto[]
###

@create[]
###


#------------------------------------------------------------------------------
#Attempt to create directory
#
#:param dir type string
#
#:result bool
#------------------------------------------------------------------------------
@createDir[dir][result]
    $test[]
    ^test.save[$dir/.parsekitkeep]
    ^file:delete[$dir/.parsekitkeep; $.keep-empty-dirs(true) $.exception(false)]
    $result(^self.exists[$dir])
###


#------------------------------------------------------------------------------
#Attempt to delete directory
#
#:param dir type string
#
#:result bool
#------------------------------------------------------------------------------
@removeDir[dir][result]
    ^file:delete[$dir; $.keep-empty-dirs(true) $.exception(false)]
    $result(!^self.exists[$dir])
###


#------------------------------------------------------------------------------
#:param dir type string
#
#:result bool
#------------------------------------------------------------------------------
@exists[dir][result]
    $result(-d '$dir')
###