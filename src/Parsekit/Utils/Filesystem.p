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
#------------------------------------------------------------------------------
@removeDir[path;mask][result]

^if(-d $path){

	$list[^file:list[$path;$mask]]

	^if($list){
		^list.menu{
			^if(-f "^self.normalize[${path}/$list.name]"){
				^file:delete[^self.normalize[${path}/$list.name]]
			}(-d "^self.normalize[${path}/$list.name]"){
                $test[]
                ^test.save[^self.normalize[^self.normalize[${path}/$list.name/.delete]]] ^rem[hack to delete empty directories]
			    $temp[^self.removeDir[^self.normalize[${path}/${list.name}/];$mask]]
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
    $result[^self.subFiles[$dir](true)]
###

@subFiles[dir;onlyDirs;onlyFiles][result]
    $dir[^self.normalize[$dir]]
    $result[^hash::create[]]
    $list[^file:list[^self.normalize[$dir/];^^[^^\.]]]
    ^list.menu{
        ^if(!^onlyDirs.int(0) || $list.dir == 1){
            ^if(!(^onlyFiles.int(0) && $list.dir == 1)){
                $result.[^result._count[]][^self.normalize[${dir}/$list.name^if($list.dir == 1){/}]]
            }
            ^if($list.dir == 1){
                $dirs[^self.subFiles[${dir}/$list.name/]($onlyDirs)($onlyFiles)]
                ^dirs.foreach[key;value]{
                    $result.[^result._count[]][^self.normalize[$value]]
                }
            }
        }
    }
