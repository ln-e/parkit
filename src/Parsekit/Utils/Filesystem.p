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


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
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
    $file[^self.normalize[$dir/.parsekitkeep]]
    $test[]
    ^test.save[$file]
    ^file:delete[$file; $.keep-empty-dirs(true) $.exception(false)]
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
    ^file:delete[^self.normalize[$dir]; $.keep-empty-dirs(true)]
    $result(!^self.exists[$dir])
###


#------------------------------------------------------------------------------
#:param dir type string
#
#:result bool
#------------------------------------------------------------------------------
@exists[dir][result]
    $result(-d $dir)
###


#------------------------------------------------------------------------------
#:param path type string
#
#:result string
#------------------------------------------------------------------------------
@normalize[path][result]
    $result[^path.replace[//;/]]
###
