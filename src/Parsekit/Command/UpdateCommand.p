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
    $requires[^hash::create[^rootPackage.getRequires[]]]

    ^if(^requires.contains[$arguments.packageName]){
        $result[Package already exist in parsekit.json. Versions requirements was changed.]
    }

    $resolvingResult[^DI:resolver.resolve[$requires](true)]


    ^if(!($resolvingResult is ResolvingResult)){
        $result[$result^taint[^#0A]Could not update requirements, as it has conflicts. Soon you will see which package cause problem, but now try your luck. ^taint[^#0A]]
    }{
        ^if($lockFile.empty){
            ^lockFile.updateFromPackage[$rootPackage]
        }

        $installResult[^DI:installer.update[$lockFile;$resolvingResult.packages]]


        ^if(^installResult.updated._count[] == 0 && ^installResult.uninstalled._count[] == 0 ){
            $result[${result}Nothing to install or update. All package is up to date.^taint[^#0A]]
        }{
            $result[$result Dependencies updated. Updated packages:^taint[^#0A]]
            ^installResult.updated.foreach[name;package]{
                $result[${result}$name^: $package.version^taint[^#0A]]
            }

            $result[${result}Removed packages:^taint[^#0A]]
            ^installResult.uninstalled.foreach[name;package]{
                $result[${result}$name^: $package.version^taint[^#0A]]
            }
        }

        ^if(^lockFile.save[]){
            $result[$result^taint[^#0A]Lockfile saved.^taint[^#0A]]
        }
    }
###
