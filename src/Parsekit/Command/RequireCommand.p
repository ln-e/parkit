# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
RequireCommand

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
#:param options type hash
#------------------------------------------------------------------------------
@execute[arguments;options][result]
    $result[]
    $packageManager[$DI:packageManager]

    $pieces[^arguments.package.split[:;h]]
    $newPackageName[^if(def $pieces.0){$pieces.0}{$arguments.package}]
    $newPackageVersion[^if(def $pieces.1){$pieces.1}{*}]

    ^try{
        $tempPackage[^packageManager.getPackage[$newPackageName]]
    }{
#       TODO make mo complicated and interactive select right version
        ^if($exception.type eq PackageNotFoundException){
            $exception.handled(true)
            $assumptions[^packageManager.guessPackage[$newPackageName]]
            $result[$result^#0A  Package '$newPackageName' not found^#0A]
            ^if(^assumptions._count[] > 0){
                $result[$result^#0A  Do you mean one of:^#0A]
                $result[$result^assumptions.foreach[key;value]{    -  $value}[^#0A]]
            }

            $newPackageName[] ^rem[ clear new package name to prevent all futher actions]
        }
    }

    ^if(def $newPackageName){
        $lockFile[^LockFile::create[/parsekit.lock]]
        $rootPackage[^packageManager.createRootPackage[/parsekit.json]]
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
#               Updates original file
                $file[^JsonFile::create[/parsekit.json]]
                $data[^file.read[]]
                $data.require.[$newPackageName][$newPackageVersion] ^rem[ OR get the installed version and "downgrade" it version to "~1.2" view ]
                ^file.write[$data;/parsekit.json]

                ^if($lockFile.empty){
                    ^lockFile.updateFromPackage[$rootPackage]
                }

                $installResult[^DI:installer.update[$lockFile;$resolvingResult.packages;$rootPackage;$options]]
                $result[$installResult.info]

#               Temporary decision. write second lock to vault dir, to compare with them while install.
#               In future this should be replaced. Current installed version should detected by exact dir.
#               Git or some kind of lock file in case of zip distribution.
                ^if(^lockFile.save[] && ^lockFile.save[/$DI:vaultDirName/parsekit.lock]){
                    $result[$result^#0A  Lockfile saved.^#0A]
                }
            }
        }
    }
###
