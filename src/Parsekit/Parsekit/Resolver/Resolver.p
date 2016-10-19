# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 23.04.16
# Time: 19:02
# To change this template use File | Settings | File Templates.

@CLASS
Resolver

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param packageManager type PackageManager
#:param semver type Parsekit/Semver/Semver
#------------------------------------------------------------------------------
@create[packageManager;semver]
    $self.packageManager[$packageManager]
    $self.semver[$semver]
###


#------------------------------------------------------------------------------
#:param requirements type hash
#:param minimumStability type string
#:param returnSingle type bool
#:param debug type bool
#
#:result hash
#------------------------------------------------------------------------------
@resolve[requirements;minimumStability;returnSingle;debug][result]
    $self.debug(^debug.int(0))
    $requirements[^hash::create[$requirements]]
    $resolvingResults[^self.step[$requirements;](1)[$minimumStability]]
    $result[$resolvingResults]

    ^if(^returnSingle.bool(true)){
        ^rem[ TODO Refactor this piece of shit ]
        $minIterations(99999)
        $minKey[]
        ^resolvingResults.foreach[k;resolvingResult]{
            ^if($resolvingResult.iterations < $minIterations){
                $minIterations($resolvingResult.iterations)
                $minKey[$k]
            }
        }

        $result[$resolvingResults.$minKey]
    }
###


#------------------------------------------------------------------------------
#:param requirements type hash
#:param transitiveMap type number
#:param iteration type number
#:param minimumStability type string
#
#:result hash
#------------------------------------------------------------------------------
@step[requirements;transitiveMap;iteration;minimumStability][result]
    $result[^hash::create[]]

    ^try{
#       We should try catch only extendRequirements and in case of pacakgeNotFoundExceotion return empty hash
        $extendResult[^self.extendRequirements[$requirements;$transitiveMap;$minimumStability]]
        $pickedPackages[$extendResult.pickedPackages]

        ^if(^extendResult.conflicts._count[]){
            ^if($self.debug){$console:line[ $iteration Conflicts: ^extendResult.conflicts.foreach[l;p]{$l^: $p^; }]}
#           We should to handle conflict. Decrease most conflict or probably each packages that participant in conflict
#           and recursivly step into next ^step
#           if conslict is unresolvable throw exception, which ^step in hight level should handle.
#           when first step throw exception we cannot install packages at all due to unresolvable conflict

            ^extendResult.conflicts.foreach[packageName;numberOfConflicts]{
                ^if($self.debug){$console:line[    Handle conflict on $iteration iteration $packageName $pickedPackages.$packageName.version
                PICKED:  ^pickedPackages.foreach[z;x]{ ** $z $pickedPackages.$z.version ** }]}
                $updatedRequirements[^hash::create[$extendResult.baseRequirements]]

                $updatedRequirements.$packageName[$updatedRequirements.$packageName <$pickedPackages.$packageName.version]
                ^try{
                    $recurrResult[^self.step[$updatedRequirements;$extendResult.transitiveMap]($iteration+1)[$minimumStability]]
                    ^recurrResult.foreach[k;rRes]{
                        $index[^result._count[]]
                        $result.$index[$rRes]
                        ^if($self.debug){$console:line[RECURR RESULT SUCCESS!! ^result._count[] ]}
                    }
                }{
                    ^if($exception.type eq RecursionPackageNotFoundException){
                        $exception.handled(true)
                    }
                }
            }
        }{
#           If no conflicts we should check, if packages has dependencies which is not
#           listed in $pickedPackages than we should add them and recursively step into next ^step
#           otherwise we finished

            ^if(^extendResult.containsNewRequirements[]){
                $result[^self.step[$extendResult.allRequirements;$extendResult.transitiveMap]($iteration+1)[$minimumStability]]
            }{
                $result[
                    $.0[^ResolvingResult::create[^self.pickPackages[$extendResult.allRequirements;$minimumStability];$iteration]]
                ]
            }
        }
        ^Erusage:compact[]
    }{
#       TODO PackageNotFoundException thrown by packageManager. It can be in case of wrong
#       package version or stability. But not conflicts. We should somehow to
#       separate this two cases: conflict and missing version by stability requirement.
        ^if($exception.type eq PackageNotFoundException){
#            $exception.handled(true)
#            $result[^hash::create[]]
        }
    }
###


#------------------------------------------------------------------------------
#Expands requirements constraint by  specifiс packages сonstraint
#
#:param newReq type hash
#:param transitiveMap type hash
#:param minimumStability type string
#
#:result ExtendingResult
#------------------------------------------------------------------------------
@extendRequirements[newReq;transitiveMap;minimumStability][result]

^if($self.debug){$console:line[>>>>>>>]}

    $extendResult[^ExtendingResult::create[$newReq]]

#    $newRequirements[^hash::create[]]

#by foreach pickedPackages we should add extra requirements to req,
#and check, if it is cause conslict, i.e. empty set with new constraint

    $transitiveNewPackages[^hash::create[]]

    $hasNew(true)
    $iterationRequirement[^hash::create[$newReq]]
    ^while($hasNew){
        $hasNew(false)

        ^try{

            $packages[^self.pickPackages[$iterationRequirement;$minimumStability]]

            ^packages.foreach[key;package]{
                ^package.require.foreach[packageName;extraReq]{

                    ^rem[collect overall requirements by picked packages]
                    ^extendResult.appendConstraint[$packageName;$extraReq]

                    ^if(def $packages.$packageName){
                        ^rem[ OLD package has new requirements. We do not change old requirement right now, just check ]
                        $packageForUpdate[$packages.$packageName]
                        ^if(!^self.semver.satisfies[$packageForUpdate.version;$newReq.[$packageForUpdate.name] $extraReq]){
                            ^rem[ conflict caused by $package ]
                            ^extendResult.addConflict[$package.name]
                        }{
                            ^if(!def $iterationRequirement.$packageName){
                                $hasNew(true)
                            }
                            $iterationRequirement.[$packageName][$iterationRequirement.[$packageName] $extraReq]
                        }
                    }{
                        $hasNew(true)
                        $iterationRequirement.[$packageName][$iterationRequirement.[$packageName] $extraReq]
                        ^extendResult.addToTransitiveMap[$packageName;$package.name]

                        ^rem[ new package ! ]
                        ^if(!def $transitiveNewPackages.$packageName){
                            $transitiveNewPackages.$packageName[^hash::create[]]
                        }
                        $transitiveNewPackages.[$packageName].[$package.name][$extraReq]
                    }

                }
            }
        }{
            ^if($exception.type eq RecursionPackageNotFoundException){
                $exception.handled(true)
            }
        }
    }


    ^rem[ compare packages new requirement between them ]
    ^transitiveNewPackages.foreach[newPackageName;reqConfig]{
        ^reqConfig.foreach[i;reqI]{
            ^reqConfig.foreach[j;reqJ]{
                ^if($i ne $j){
                    ^if(
                        !^self.semver.constraintIntersected[$reqI;$reqJ]
                        ||
                        !def ^self.pickPackages[$.$newPackageName[$reqI $reqJ];$minimumStability]
                    ){
                        ^if($self.debug){$console:line[TRNASITIVNIY $newPackageName between $i $packages.$i.version [$reqI] and $j $packages.$j.version [$reqJ] ]}
                        ^rem[ conflict between $i and $j ]
                        ^extendResult.addConflict[$i]
                        ^extendResult.addConflict[$j]
                    }
                }
            }
        }
    }

    ^extendResult.extendConflictsByTransitiveMap[]
    $extendResult.pickedPackages[$packages]
    $result[$extendResult]
    ^if($self.debug){$console:line[<<<<<<<<]}
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
@pickPackageByStrategy[strategy;packages;constraint][result]
    $result[]
    ^if($strategy ne max){
        ^throw[unknown.strategy;Resolver.p;Strategy $strategy is not implemented]
    }
    ^if(!def $packages || ^packages._count[] <= 0){
        ^throw[empty.packages;;Packages list is empty]
    }

    $versions[^hash::create[]]
    ^packages.foreach[key;pack]{
        $index[^versions._count[]]
        $versions.$index[$pack.version]
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


#------------------------------------------------------------------------------
#:param requirements type hash
#:param minimumStability type string
#
#:result hash
#------------------------------------------------------------------------------
@pickPackages[requirements;minimumStability][result]
    $result[^hash::create[]]
    ^requirements.foreach[packageName;baseConstraint]{
        $packages[^self.packageManager.getPackage[$packageName;$minimumStability]]

#       Pick package nearest to $constraint top boundary
        $package[^self.pickPackageByStrategy[max;$packages;^taint[as-is][$baseConstraint]]]

        ^if(!($package is PackageInterface)){
            ^if($self.debug){$console:line[Could not find package '$packageName' from set with length ^packages._count[] satisfied '^taint[as-is][$baseConstraint]' ]}
            ^throw[RecursionPackageNotFoundException;Resolver.p; Could not find package '$packageName' satisfied '^taint[as-is][$baseConstraint]' ]
        }

        $result.[$package.name][$package]
    }
    ^if($self.debug){$console:line[PICKED ^result.foreach[i;k]{$i $k.version}[ ]]}
###
