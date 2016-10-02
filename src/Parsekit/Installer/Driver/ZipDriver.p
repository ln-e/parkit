# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 04.05.16
# Time: 10:20
# To change this template use File | Settings | File Templates.

@CLASS
ZipDriver

@OPTIONS
locals

@BASE
ArchiveDriver

@auto[]
###

#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[filesystem]
    ^BASE:create[$filesystem]
###


#------------------------------------------------------------------------------
#:param dir type string destination folder
#:param fileInfo type hash unpacking archive information
#
#:result hash
#------------------------------------------------------------------------------
@unpack[dir;fileInfo]
    ^if(^Exec:isWin[]){
        $command[^Exec::create[7z e -o.^file:basename[$fileInfo.filePath];$fileInfo.tempDir]]
    }{
        $command[^Exec::create[unzip .$fileInfo.filePath -d .$fileInfo.tempDir;]]
    }
    ^if(!^command.execute[]){
        ^throw[UnzipFailedException;;Could nor execute command ^command.toString[]]
    }
    $zipname[^self.guessUnzipFoldername[$fileInfo.tempDir;^file:basename[$fileInfo.filePath]]]
    ^file:move[${fileInfo.tempDir}$zipname;$dir]
    $result(true)
###


#------------------------------------------------------------------------------
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@supports[url]
    $result(^url.match[(.zip^$)|(.tar.gz^$)|(api.github.com\/\S+\/zipball\/[a-zA-Z0-9]{40})][in] > 0)
###


#------------------------------------------------------------------------------
#Try to guess unzipped folder name
#
#:param dir type string Directory with archive
#:param zipName type hash Name of the zip file
#
#:result hash
#------------------------------------------------------------------------------
@guessUnzipFoldername[dir;zipName][result]
  $files[^file:list[$dir;$.stat(true)]]
  $files[^files.select($files.dir == 1)]
  ^files.sort($files.mdate)
  $result[$files.fields.name]
###
