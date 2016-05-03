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
@removeDir[path;mask][result]

^if(-d $path){

	$list[^file:list[$path;$mask]]

	^if($list){
		^list.menu{
			^if(-f "${path}$list.name"){
				^file:delete[${path}$list.name]
			}(-d "${path}$list.name"){
                $test[]
                ^test.save[^self.normalize[${path}$list.name/.delete]] ^rem[hack to delete empty directories]
			    ^self.removeDir[${path}${list.name}/;$mask]
			}
		}
	}

}
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
    $result[^path.match[\/{1,}][g]{/}]
###


#------------------------------------------------------------------------------
#:param dir type string
#
#:result hash
#------------------------------------------------------------------------------
@subDirs[dir][result]
    $dir[^self.normalize[$dir]]
    $result[^hash::create[]]
    $list[^file:list[^self.normalize[$dir/];^^[^^\.]]]
    ^list.menu{
        ^if($list.dir == 1){
            $result.[^result._count[]][^self.normalize[${dir}/$list.name]]
            $dirs[^self.subDirs[${dir}/$list.name/]]
            ^dirs.foreach[key;value]{
                $result.[^result._count[]][^self.normalize[$value/]]
            }
        }
    }

###
