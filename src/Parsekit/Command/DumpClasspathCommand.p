# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 03.05.16
# Time: 18:40
# To change this template use File | Settings | File Templates.

@CLASS
DumpClasspathCommand

@OPTIONS
locals

@BASE
Ln-e/Console/CommandInterface


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    ^BASE:create[]
###


#------------------------------------------------------------------------------
#Configure command
#------------------------------------------------------------------------------
@configure[]
    $self.name[dumpclasspath]
    $self.description[generates new $DI:vaultDirName/classpath.p file for extend ^$MAIN:CLASS_PATH]
    ^self.addOption[debug;d;;Enabling debug output]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param input type Ln-e/Console/Input/InputInterface
#:param output type Ln-e/Console/Output/OutputInterface
#
#:result string
#------------------------------------------------------------------------------
@execute[input;output][result]
    $result[]

    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]
    $lockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]

    ^if($lockFile.empty){
        $result[parsekit.lock file not found! Could not dump autoload file. May be you mean `parsekit update` command ?]
    }{
        $packages[^DI:packageManager.packagesFromLock[$lockFile]]
        ^DI:installer.dumpClassPath[$rootPackage;$packages]

        $result[Classpath file $DI:vaultDirName/classpath.p was updated]
    }
###
