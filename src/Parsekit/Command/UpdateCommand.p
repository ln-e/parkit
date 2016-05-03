# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
UpdateCommand

@USE
CommandInterface.p
CommandArgument.p
Parsekit/Repository/RepositoryFactory.p
Parsekit/Package/PackageManager.p
Parsekit/Package/LockFile.p

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
    $result[updates installed dependencies according to require constraints in parsekit.json]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[^hash::create[]]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#------------------------------------------------------------------------------
@execute[arguments][result]
    $result[]

    $lockFile[^LockFile::create[/parsekit.lock]]

    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]
    $requires[^hash::create[$rootPackage.requires]]

    $resolvingResult[^DI:resolver.resolve[$requires](true)]


    ^if(!($resolvingResult is ResolvingResult)){
        $result[$result^taint[^#0A]Could not update requirements, as it has conflicts. Soon you will see which package cause problem, but now try your luck. ^taint[^#0A]]
    }{
        ^if($lockFile.empty){
            ^lockFile.updateFromPackage[$rootPackage]
        }

        $installResult[^DI:installer.update[$lockFile;$resolvingResult.packages]]
        $result[$installResult.info]

#       Temporary decision. write second lock to vault dir, to compare with them while install.
#       In future this should be replaced. Current installed version should detected by exact dir.
#       Git or some kind of lock file in case of zip distribution.
        ^if(^lockFile.save[] && ^lockFile.save[/$DI:vaultDirName/parsekit.lock]){
            $result[$result^taint[^#0A]  Lockfile saved.^taint[^#0A]]
        }
    }
###
