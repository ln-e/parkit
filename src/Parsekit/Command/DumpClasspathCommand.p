# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 03.05.16
# Time: 18:40
# To change this template use File | Settings | File Templates.

@CLASS
DumpClasspathCommand

@USE
CommandInterface.p
CommandArgument.p
CommandOption.p

@OPTIONS
locals

@BASE
CommandInterface


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_description[]
    $result[generates new $DI:vaultDirName/classpath.p file for extend ^$MAIN:CLASS_PATH]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[^hash::create[]]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_optionsConfig[]
    $result[^hash::create[
        $.0[^CommandOption::create[debug;d;;Enabling debug output]]
    ]]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#------------------------------------------------------------------------------
@execute[arguments][result]
    $result[]

    $lockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]

    ^if($lockFile.empty){
        $result[parsekit.lock file not found! Could not dump autoload file. May be you mean `parsekit update` command ?]
    }{
        $packages[^DI:packageManager.packagesFromLock[$lockFile]]
        ^DI:installer.dumpClassPath[$packages]

        $result[Classpath file $DI:vaultDirName/classpath.p was updated]
    }
###
