# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
RequireCommand

@USE
CommandInterface.p
CommandArgument.p
Parsekit/Repository/RepositoryFactory.p
Parsekit/Package/PackageManager.p

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
    $result[add dependency to project. NOT IMPELEMENTED YET.]
###


#------------------------------------------------------------------------------
#:result hash
#------------------------------------------------------------------------------
@GET_argumentsConfig[]
    $result[
        ^hash::create[
            $.package[
                ^CommandArgument::create[package;true]
            ]
        ]
    ]
###


#------------------------------------------------------------------------------
#Command execution
#
#:param arguments type hash
#:param options type hash
#------------------------------------------------------------------------------
@execute[arguments;options][result]
    $result[]
    $pieces[^arguments.package.split[:;h]]
    $newPackageName[^if(def $pieces.0){$pieces.0}{$arguments.package}]
    $newPackageVersion[^if(def $pieces.1){$pieces.1}{*}]
    $lockFile[^LockFile::create[/parsekit.lock]]

    $rootPackage[^DI:packageManager.createRootPackage[/parsekit.json]]
    $requires[^hash::create[$rootPackage.requires]]

    ^if(^requires.contains[$newPackageName]){
        $result[Package $newPackageName already in parsekit.json]
    }{
        $requirements[^lockFile.getInstalledRequirements[]]
        $requirements.[$newPackageName][$newPackageVersion]
        $resolvingResult[^DI:resolver.resolve[$requirements](true)]

        ^if(!($resolvingResult is ResolvingResult)){
            $result[$result^#0ACould not update requirements, as it has conflicts. Soon you will see which package cause problem, but now try your luck. ^#0A]
        }{
#           Updates original file
            $file[^JsonFile::create[/parsekit.json]]
            $data[^file.read[]]
            $data.require.[$newPackageName][$newPackageVersion] ^rem[ OR get the installed version and "downgrade" it version to "~1.2" view ]
            ^file.write[$data;/parsekit.json]

            ^if($lockFile.empty){
                ^lockFile.updateFromPackage[$rootPackage]
            }

            $installResult[^DI:installer.update[$lockFile;$resolvingResult.packages;$rootPackage;$options]]
            $result[$installResult.info]

#           Temporary decision. write second lock to vault dir, to compare with them while install.
#           In future this should be replaced. Current installed version should detected by exact dir.
#           Git or some kind of lock file in case of zip distribution.
            ^if(^lockFile.save[] && ^lockFile.save[/$DI:vaultDirName/parsekit.lock]){
                $result[$result^#0A  Lockfile saved.^#0A]
            }
        }
    }
###
