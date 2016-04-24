# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:43
# To change this template use File | Settings | File Templates.

@CLASS
PackageManager

@OPTIONS
locals

@USE
BasePackage.p
RootPackage.p

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#:param repositoryManager type RepositoryManager
#------------------------------------------------------------------------------
@create[repositoryManager]
    $self.repositoryManager[$repositoryManager]
    $self.packages[^hash::create[]]
###


@getPackages[name][result]
# TODO get list of repositories instead of direct access to parsekitRepository
    $parsekitRepository[$self.repositoryManager.parsekitRepository]

    ^if(!def $parsekitRepository.lazyPackages.$name){
        ^throw[lazypackagenotfound]
    }

# Если еще не был загружен этот пакет
    ^if(!def $self.packages.$name){
        $config[^parsekitRepository.loadPackages[$name]]

        ^config.foreach[packageName;packagesConfig]{
            ^if(!def $self.packages.$packageName){
                $self.packages.$packageName[^hash::create[]]
            }
# Перебираем все пакеты и создаем из них классы
            ^packagesConfig.foreach[tag;config]{
                $package[^self.createPackage[$parsekitRepository;$config]]
                $index[^self.packages.$packageName._count[]]
                $self.packages.$packageName.$index[$package]
            }
        }

    }

    $result[$self.packages.$name]
##


#------------------------------------------------------------------------------
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@createRootPackage[config][result]
    $root[^RootPackage::create[$config.name]]
    $package[^self.configurePackage[$root;$config]]
    $result[$package]
###


#------------------------------------------------------------------------------
#:param repository type RepositoryInterface
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@createPackage[repository;config][result]
    $package[^self.configurePackage[^BasePackage::create[$config.name];$config]]
    $package.setRepository[$repository]
    $result[$package]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#:param config type hash
#:result PackageInterface
#------------------------------------------------------------------------------
@configurePackage[package;config][result]

    ^package.setType[$config.type]
    ^package.setTargetDir[$config.targetDir]
    ^package.setSourceType[$config.sourceType]
    ^package.setSourceUrl[$config.sourceUrl]
    ^package.setSourceReference[$config.sourceReference]
    ^package.setReleaseDate[$config.releaseDate]

    ^package.setUniqueName[$config.uniqueName]

    ^package.setVersion[$config.version]
    ^package.setPrettyVersion[$config.prettyVersion]
    ^package.setFullPrettyVersion[$config.fullPrettyVersion]
    ^package.setStability[$config.stability]

    ^if($config.require is hash){
        ^config.require.foreach[packageName;constraint]{
            ^if(^packageName.lower[] eq parser){
                ^continue[]
            }
            ^package.addToPackageList[$packageName;$constraint]
        }
    }

    ^rem{^if($config.devRequire is hash){
        ^config.devRequire.foreach[packageName;constraint]{
# ho ho ho but we should have here PackageInterface ?
            ^package.addRequire[
                $.name[$packageName]
                $.constraint[$constraint]
            ]
        }
    }}

#    $package.setRequires[^hash::create[]$config.requires]
#    $package.setDevRequires[^hash::create[]$config.devRequires]


    $result[$package]
###
