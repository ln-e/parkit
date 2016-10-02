# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
UpdateCommand

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


@configure[]
    $self.name[update]
    $self.description[updates installed dependencies according to require constraints in parsekit.json]
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

    $installedLockFile[^LockFile::create[/$DI:vaultDirName/parsekit.lock]]

    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]
    $requires[^hash::create[$rootPackage.requires]]

    $resolvingResult[^DI:resolver.resolve[$requires](true;^input.getArgument[debug])]


    ^if(!($resolvingResult is ResolvingResult)){
        $result[$result^#0ACould not update requirements, as it has conflicts. Soon you will see which package cause problem, but now try your luck. ^#0A]
    }{
        ^if($installedLockFile.empty){
            ^installedLockFile.updateFromPackage[$rootPackage]
        }

        $installResult[^DI:installer.update[$installedLockFile;$resolvingResult.packages;$rootPackage;$input.options]]
        $result[$installResult.info]

#       Write second lock to vault dir, to know currently installed version
        ^if(^installedLockFile.save[] && ^installedLockFile.save[/parsekit.lock]){
            $result[$result^#0A  Lockfile saved.^#0A]
        }
    }
###
