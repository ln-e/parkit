# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 23.04.16
# Time: 19:02
# To change this template use File | Settings | File Templates.

@CLASS
Resolver

@USE
Package/PackageManager.p
Version/VersionParser.p
ExtendingResult.p
ResolvingResult.p

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:param packageManager type PackageManager
#------------------------------------------------------------------------------
@create[packageManager;semver]
    $self.packageManager[$packageManager]
    $self.semver[$semver]
###


#------------------------------------------------------------------------------
#:param rootPackage type RootPackage
#------------------------------------------------------------------------------
@resolve[rootPackage][result;newRequirements]
    $self.rootPackage[$rootPackage]
    $self.baseRequirements[^hash::create[]]
    $requirements[^hash::create[^rootPackage.getPackagesList[]]]

    $result[^self.step[$requirements;$requirements](1)]
###


#------------------------------------------------------------------------------
#:param requirements type hash
#:param iteration type number
#------------------------------------------------------------------------------
@step[origin;requirements;iteration][result;packageName;packages;pickedPackages;extendResult;base;req;packageName;baseConstraint;compareConstraint;package]
    $result[^hash::create[]]
    $pickedPackages[^hash::create[]]
    $req[^hash::create[$requirements]]


    ^requirements.foreach[packageName;baseConstraint]{
        $console:line[package name = '$packageName']
        $packages[^self.packageManager.getPackages[$packageName]]
# Pick package nearest to $constraint top boundary


        $package[^self.pickPackageByStrategy[max;$packages;^taint[as-is][$baseConstraint]]]

        ^if(!($package is PackageInterface)){
            $console:line[Could not find package '$packageName' from set with length ^packages._count[] ($packages.1.name $packages.1.version ) satisfied '$compareConstraint' ]
            ^throw[RecursionPackageNotFoundException;Resolver.p; Could not find package '$packageName' satisfied '$compareConstraint' ]
        }

        $pickedPackages.[$package.name][$package]
    }

    ^if(^pickedPackages._count[] < ^requirements._count[]){
        ^throw[piectofshit]
    }

    $extendResult[^self.extendRequirements[$req;$pickedPackages]]

    ^if(^extendResult.conflicts._count[]){
#We should to handle conflict. Decrease most conflict or probably each packages that participant in conflict
#and recursivly step into next ^step
#if conslict is unresolvable throw exception, which ^step in hight level should handle.
#when first step throw exception we cannot install packages at all due to unresolvable conflict

        ^extendResult.conflicts.foreach[packageName;numberOfConflicts]{
            $console:line[??? $iteration  $packageName $pickedPackages.$packageName.version  ^extendResult.conflicts.foreach[z;x]{ ** $z $pickedPackages.$z.version ** } $numberOfConflicts]
            $updatedRequirements[^hash::create[$requirements]]

            $updatedRequirements.$packageName[$updatedRequirements.$packageName <$pickedPackages.$packageName.version]
            ^try{
                $recurrResult[^self.step[$origin;$updatedRequirements]($iteration+1)]
                ^recurrResult.foreach[k;rRes]{
                    $index[^result._count[]]
                    $result.$index[$rRes]
                }
            }{
                $console:line[failed]
                ^if($exception.type eq RecursionPackageNotFoundException){
                    $exception.handled(true)
                }
            }
        }
        $console:line[$iteration 234234234234234234 $extendResult.conflicts[test/c]]
    }{
#If no conflicts we should check, if packages has dependencies which is not
#listed in $pickedPackages than we should add them and recursively step into next ^step
#otherwise we finished
^if($iteration>20){^dstop[$extendResult]}
        ^if(^extendResult.containsNewRequirements[]){

            $result[^self.step[$origin;$extendResult.allRequirements]($iteration+1)]

^extendResult.allRequirements.foreach[o;h]{
                ^dstop[$o $h]
            }

        }{
            $result[
                $.0[^ResolvingResult::create[$pickedPackages;$iteration]]
            ]
        }
    }
###


#------------------------------------------------------------------------------
#:param newReq type hash
#:param packages type hash
#
#:TODO expand req constraint by pickedPackagesConstraint
#
#:result ExtendingResult
#------------------------------------------------------------------------------
@extendRequirements[newReq;packages][result]

    $extendResult[^ExtendingResult::create[$newReq]]

    $newRequirements[^hash::create[]]
    $req[^hash::create[$newReq]]

#by foreach pickedPackages we should add extra requirements to req,
#and check, if it is cause conslict, i.e. empty set with new constraint

    $transitiveNewPackages[^hash::create[]]


    ^packages.foreach[key;package]{
        ^package.packagesList.foreach[packageName;extraReq]{

            ^rem[collect overall requirements by picked packages]
            ^extendResult.appendConstraint[$packageName;$extraReq]


            ^if(def $packages.$packageName){
                ^rem[ OLD package has new requirements. We do not change old requirement right now, just check ]
                $packageForUpdate[$packages.$packageName]
                ^if(!^self.semver.satisfies[$packageForUpdate.version;$req.[$packageForUpdate.name] $extraReq]){
                    ^rem[ conflict caused by $package ]
                    ^extendResult.addConflict[$package.name]
                }{
                    ^if(!def $newRequirements.$packageName){
                        $newRequirements.$packageName[^hash::create[]]
                    }
                    $newRequirements.$packageName.[$package.name][$extraReq]
                }
            }{
                ^rem[ new package ! ]
                ^if(!def $transitiveNewPackages.$packageName){
                    $transitiveNewPackages.$packageName[^hash::create[]]
                }
                $transitiveNewPackages.[$packageName].[$package.name][$extraReq]
            }

        }
    }

    ^rem[ compare packages new requirement between them ]
    ^newRequirements.foreach[newPackageName;reqConfig]{
        ^reqConfig.foreach[i;reqI]{
            ^reqConfig.foreach[j;reqj]{
                ^if($i ne $j){
                    ^if(!^self.semver.satisfies[$reqI;$reqJ]){
                        ^rem[ conflict between $i and $j ]
                        ^extendResult.addConflict[$i]
                        ^extendResult.addConflict[$j]
                    }
                }
            }
        }
    }

    ^rem[ compare packages new requirement between them ]
    ^transitiveNewPackages.foreach[newPackageName;reqConfig]{
        ^reqConfig.foreach[i;reqI]{
            ^reqConfig.foreach[j;reqj]{
                ^if($i ne $j){
                    ^if(
                        !^self.semver.constraintIntersected[$reqI;$reqJ]
                        ||
                        !def ^self.pickPackageByStrategy[max;^self.packageManager.getPackages[$newPackageName];$reqI $reqJ]
                    ){
                        ^rem[ conflict between $i and $j ]
                        ^extendResult.addConflict[$i]
                        ^extendResult.addConflict[$j]
                    }
                }
            }
        }
    }


    $result[$extendResult]
    $console:line[Conflicts: ^extendResult.conflicts.foreach[l;p]{$l^: $p^; }]
###


#------------------------------------------------------------------------------
# Selects one package from set of packages satisties givin constraint by strategy
#
#:param strategy type string
#:param packages type hash
#:param constraint type string
#
#:result PackageInterface
#------------------------------------------------------------------------------
@pickPackageByStrategy[strategy;packages;constraint;debug][result;key;package;index;versions;constraint]
    $result[]
    ^if($strategy ne max){
        ^throw[unknown.strategy;Resolver.p;Strategy $strategy is not implemented]
    }
    ^if(!def $packages || ^packages._count[] <= 0){
        ^throw[empty.packages;Resolver.p;Packages list is empty]
    }

    $versions[^hash::create[]]
    ^packages.foreach[key;pack]{
        ^rem[ TODO откуда берется не PackageInterface в packages ?]
        ^if($pack is PackageInterface){
            $index[^versions._count[]]
            $versions.$index[$pack.version]
        }
    }

    $versions[^self.semver.sort[^self.semver.satisfiedBy[$versions;$constraint]]]
    ^rem[ After that ^$versions.0 will contain the biggest package version]

    ^packages.foreach[key;package]{
        ^if($package is PackageInterface){
            ^if(^self.semver.satisfies[$package.version;$versions.0]){
                $result[$package]
                ^break[]
            }
        }
    }
###
