# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 9:50
# To change this template use File | Settings | File Templates.

@CLASS
Exec

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#TODO EXTREMLY IMPORTANT! Check for a potentially critical security issues!
#
#:constructor
#
#:param command type string
#:param dir type string optional
#------------------------------------------------------------------------------
@create[command;dir;successCode]
    $self.command[$command]
    $self.dir[$dir]
    $self.root[$request:document-root]
    $self.successCode[^if(def $successCode){$successCode}{0}]
    $self.cd[]
    ^self.updateDir[$dir]
###


#------------------------------------------------------------------------------
#:param dir type string optional directory from webroot
#
#:result bool
#------------------------------------------------------------------------------
@execute[dir][result]
    ^if($dir){
        ^self.updateDir[$dir]
    }
#    $console:line[Execute '$cd $self.command']
    $self.file[^file::exec[eval.sh;;$cd $self.command]]
    $result($self.status == $self.successCode)
###


#------------------------------------------------------------------------------
#:param dir type string
#------------------------------------------------------------------------------
@updateDir[dir][result]
    ^if(def $dir){
        $self.dir[$dir]
    }
    $fullPath[${self.root}$self.dir]
    $self.cd[cd^if(^Exec:isWin[]){/D } ^fullPath.replace[//;/] && ]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@GET_text[][result]
    ^if(!def $self.file){
        ^self.execute[]
    }
    $result[$self.file.text]
###


#------------------------------------------------------------------------------
#:result number
#------------------------------------------------------------------------------
@GET_status[][result]
    $result[$self.file.status]
###


#------------------------------------------------------------------------------
#:result bool
#------------------------------------------------------------------------------
@static:isWin[][result]
    $result(^env:PARSER_VERSION.match[pc-win][in] > 0)
###
