# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:43
# To change this template use File | Settings | File Templates.

@CLASS
PackageManager

@OPTIONS
locals
static

@USE
BasePackage.p
RootPackage.p

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@static:createRootPackage[config][result]
    $package[^PackageManager:configurePackage[^RootPackage::create[$config.name];$config]]
    $result[$package]
###


#------------------------------------------------------------------------------
#:param repository type RepositoryInterface
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@static:createPackage[repository;config][result]
    $package[^PackageManager:configurePackage[^BasePackage::create[$config.name]]]
    $package.setRepository[$repository]
    $result[package]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@static:configurePackage[package;config][result]

    $package.setType[$config.type]
    $package.setTargetDir[$config.targetDir]
    $package.setSourceType[$config.sourceType]
    $package.setSourceUrl[$config.sourceUrl]
    $package.setSourceReference[$config.sourceReference]
    $package.setReleaseDate[$config.releaseDate]

    $package.setUniqueName[$config.uniqueName]

    $package.setVersion[$config.version]
    $package.setPrettyVersion[$config.prettyVersion]
    $package.setFullPrettyVersion[$config.fullPrettyVersion]
    $package.setStability[$config.stability]

    ^if($config.require is hash){
        ^config.require.foreach[packageName;constraint]{
# ho ho ho but we should have here PackageInterface ?
            ^package.addRequire[
                $.name[$packageName]
                $.constraint[$constraint]
            ]
        }
    }

    ^if($config.devRequire is hash){
        ^config.devRequire.foreach[packageName;constraint]{
# ho ho ho but we should have here PackageInterface ?
            ^package.addRequire[
                $.name[$packageName]
                $.constraint[$constraint]
            ]
        }
    }

#    $package.setRequires[^hash::create[]$config.requires]
#    $package.setDevRequires[^hash::create[]$config.devRequires]


    $result[$package]
###
