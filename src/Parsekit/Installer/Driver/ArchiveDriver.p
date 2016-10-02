# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 03.05.16
# Time: 22:37
# To change this template use File | Settings | File Templates.

@CLASS
ArchiveDriver

@OPTIONS
locals

@BASE
DriverInterface

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[filesystem]
    $self.filesystem[$filesystem]
###


#------------------------------------------------------------------------------
#:param dir type string destination folder
#:param file type file unpacking archive
#
#:result hash
#------------------------------------------------------------------------------
@unpack[dir;file]
    ^throw[Abstract method not implemented]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@mount[dir;package][result]
#   Update == Install for zip archive
    ^self.doInstall[$dir;$package]
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@doInstall[dir;package][result]
    $bakDir[^self.tempdirForPackage[$package]/${package.targetDir}_bak]
    ^if(^self.filesystem.exists[$bakDir]){
        ^self.filesystem.removeDir[$bakDir]
    }
    ^if(^self.filesystem.exists[$dir]){
        ^file:move[$dir;$bakDir]
    }

    $fileInfo[^self.getDist[$package]]
    $result[^self.unpack[$dir;$fileInfo]]

    ^if(!$result){
      ^file:move[$bakDir;$dir]
    }{
      ^self.filesystem.removeDir[$bakDir]
    }

    ^self.filesystem.removeDir[^file:dirname[$fileInfo.filePath]]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#
#:result hash
#------------------------------------------------------------------------------
@getDist[package][result]
    $result[]
    $url[$package.distUrl]
    $attempts(3)

    ^while($attempts > 0){
        $file[^self.loadUrl[$url]]
        ^if($file.size == 0){
            ^attempts.dec[]
            ^if(^Application:hasOption[debug]){$console:line[File $url corrupted, retry.]}
        }{
            $attempts(0)
            $tmpDir[^self.tempdirForPackage[$package]]
            $recreate(^self.filesystem.removeDir[$tmpDir])
            $recreate(^self.filesystem.createDir[$tmpDir])

            ^if(!$recreate){ ^throw[filesystemException;;Could not recreate temp directory for package $package.name ]}

            $filePath[${tmpDir}^self.contentDispositionName[$file]]
            ^file.save[binary;$filePath]

            $result[
              $.tempDir[$tmpDir]
              $.filePath[$filePath]
              $.file[$file]
            ]
        }
    }
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#
#:result string
#------------------------------------------------------------------------------
@tempdirForPackage[package]
    $result[/$DI:vaultDirName/.tmp/${package.targetDir}/]
###


#------------------------------------------------------------------------------
#:param url type string
#
#:result file
#------------------------------------------------------------------------------
@loadUrl[url][result]
#   TODO add extra check for uri
    $result[^curl:load[
        $.url[^taint[as-is][$url]]
        $.useragent[parsekit]
        $.timeout(20)
        $.ssl_verifypeer(0)
        $.followlocation(1)
        $.mode[binary]
    ]]
###


#------------------------------------------------------------------------------
#:param file type file
#
#:result string
#------------------------------------------------------------------------------
@contentDispositionName[file][result]
    $result[]
    $headers[^json:parse[^json:string[$file]]]
    ^if($headers is hash && ^headers.contains[CONTENT-DISPOSITION]){
        $matches[^headers.CONTENT-DISPOSITION.match[filename=(^[^^^;\s^]*)][i]]
        $name[$matches.1]
        $result[$name]
    }
###
