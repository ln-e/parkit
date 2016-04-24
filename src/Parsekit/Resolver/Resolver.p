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
@create[packageManager]
    $self.packageManager[$packageManager]
###


#:param rootPackage type RootPackage
@resolve[rootPackage]
    $self.rootPackage[$rootPackage]
    $self.baseRequirements[^hash::create[]]
#    $self.defaultRequire[^hash::create[^root.getPackagesList[]]]
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
        $index[^pickedPackages._count[]]
        $pickedPackages.$index[$package]
    }

    $extendResult[^self.extendRequirements[$req;$pickedPackages]]
    ^if($extendResult.conflicts){
#We should to handle conflict. Decrease most conflict or probably each packages that participant in conflict
#and recursivly step into next ^step
#if conslict is unresolvable throw exception, which ^step in hight level should handle.
#when first step throw exception we cannot install packages at all due to unresolvable conflict
    }{
#If no conflicts we should check, if packages has dependencies which is not
#listed in $pickedPackages than we should add them and recursively step into next ^step
#otherwise we finished
    }
    ^dstop[123]
###

#:TODO expand req constraint by pickedPackagesConstraint
@extendRequirements[req;pickedPackages][result]

    ^dstop[$pickedPackages]

    $result[
        $.conflicts(false)
    ]
###


#:param strategy type string
#:param packages type hash
#:param constraint type string
#:result PackageInterface
@pickPackageByStrategy[strategy;packages;constraint][result]
    ^if($strategy ne max){
        ^throw[unknown.strategy;Resolver.p;Strategy $strategy is not implemented]
    }
    ^if(^packages._count[] <= 0){
        ^throw[empty.packages;Resolver.p;Packages list is empty]
    }
    $pickedPackage[$packages._at(0)]
    ^packages.foreach[key;package]{
        ^if(^reflection:uid[$package] ne ^reflection:uid[$pickedPackage]){
            ^dstop[^VersionParser:normalize[$package.version]]
        }
    }
    ^dstop[$packages]
    ^dstop[$constraint]
###
