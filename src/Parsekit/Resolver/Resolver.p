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

@OPTIONS
locals

@auto[]
###


#:param packageManager type PackageManager
@create[packageManager;semver]
    $self.packageManager[$packageManager]
    $self.semver[$semver]
###


#:param rootPackage type RootPackage
@resolve[rootPackage][result;newRequirements]
    $self.rootPackage[$rootPackage]
    $self.baseRequirements[^hash::create[]]
    $newRequirements[^hash::create[^rootPackage.getPackagesList[]]]

    $result[^self.step[$newRequirements]]
###


@step[newRequirements]
    $req[^hash::create[$newRequirements]]
    $pickedPackages[^hash::create[]]

    ^newRequirements.foreach[packageName;constraint]{
        $packages[^self.packageManager.getPackages[$packageName]]
# Pick package nearest to $constraint top boundary
        $package[^self.pickPackageByStrategy[max;$packages;$constraint]]
        ^if(!def $package){
            ^throw[PackageNotFoundException;Resolver.p; Could not find package '$packageName' satisfied '$constraint' ]
        }

        $pickedPackages.[$package.name][$package]
    }

    $extendResult[^self.extendRequirements[$req;$pickedPackages]]

    ^if(^extendResult.conflicts._count[]){
        ^dstop[$extendResult]
#We should to handle conflict. Decrease most conflict or probably each packages that participant in conflict
#and recursivly step into next ^step
#if conslict is unresolvable throw exception, which ^step in hight level should handle.
#when first step throw exception we cannot install packages at all due to unresolvable conflict
    }{
#If no conflicts we should check, if packages has dependencies which is not
#listed in $pickedPackages than we should add them and recursively step into next ^step
#otherwise we finished
    }
###


#:param newReq type hash
#:param packages type hash
#
#:TODO expand req constraint by pickedPackagesConstraint
#
#:result hash
@extendRequirements[newReq;packages][result]

    $extendResult[
        $.conflicts[^hash::create[]]
        $.oldReq[^hash::create[$newReq]]
        $.allReq[^hash::create[$newReq]]
    ]

    $newRequirements[^hash::create[]]
    $req[^hash::create[$newReq]]

#by foreach pickedPackages we should add extra requirements to req,
#and check, if it is cause conslict, i.e. empty set with new constraint

    $transitiveNewPackages[^hash::create[]]


    ^packages.foreach[key;package]{
        ^package.packagesList.foreach[packageName;extraReq]{

            ^rem[collect overall requirements by picked packages]
            $extendResult.allReq.[$packageName][$extendResult.allReq.[$packageName] $extraReq]


            ^if(def $packages.$packageName){
                ^rem[ OLD package has new requirements. We do not change old requirement right now, just check ]
                $packageForUpdate[$packages.$packageName]
                ^if(!^self.semver.satisfies[$packageForUpdate.version;$req.[$packageForUpdate.name] $extraReq]){
                    ^rem[ conflict caused by $package ]
                    ^extendResult.conflicts.[$package.name].inc(1)
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
                        $extendResult.conflicts.[$i]($extendResult.conflicts.$i+1)
                        $extendResult.conflicts.[$j]($extendResult.conflicts.$j+1)
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
                        $extendResult.conflicts.[$i]($extendResult.conflicts.$i+1)
                        $extendResult.conflicts.[$j]($extendResult.conflicts.$j+1)
                    }
                }
            }
        }
    }


    $result[$extendResult]
###



@updateRequirements[requirements;packageName;newConstraint][result;parser]
    $parser[$self.semver.versionParser]
    $constraintA[^parser.parseConstraints[$requirements.$packageName]]
    $constraintB[^parser.parseConstraints[newConstraint]]
    ^dstop[^constraintB.matches[$constraintA]]
    $requirements.$packageName[$requirements.$packageName $newRequirement]
###




#:param strategy type string
#:param packages type hash
#:param constraint type string
#
#:result PackageInterface
@pickPackageByStrategy[strategy;packages;constraint][result]
    ^if($strategy ne max){
        ^throw[unknown.strategy;Resolver.p;Strategy $strategy is not implemented]
    }
    ^if(!def $packages || ^packages._count[] <= 0){
        ^throw[empty.packages;Resolver.p;Packages list is empty]
    }
    $pickedPackage[$packages._at(0)]
    $versions[^hash::create[]]
    ^packages.foreach[key;package]{
        ^rem[ TODO откуда берется не PackageInterface в packages ?]
        ^if($package is PackageInterface){
            $index[^versions._count[]]
            $versions.$index[$package.version]
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
