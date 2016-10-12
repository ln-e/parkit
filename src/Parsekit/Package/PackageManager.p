# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:43
# To change this template use File | Settings | File Templates.

@CLASS
PackageManager

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param repositoryManager type RepositoryManager
#:param versionParser type VersionParser
#------------------------------------------------------------------------------
@create[repositoryManager;versionParser]
    $self.versionParser[$versionParser]
    $self.repositoryManager[$repositoryManager]
    $self.packages[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param name type string
#
#:result PackageInterface
#------------------------------------------------------------------------------
@getPackage[name][result]
#   TODO get list of repositories instead of direct access to parsekitRepository
    $parsekitRepository[$self.repositoryManager.parsekitRepository]

    ^if(!def $parsekitRepository.lazyPackages.$name){
        ^throw[PackageNotFoundException;PackageManager.p; Package with name '$name' not found ]
    }

#   if package is not listed yet
    ^if(!def $self.packages.$name){
        $config[^parsekitRepository.loadPackages[$name]]

        ^config.foreach[packageName;packagesConfig]{
            ^if(!def $self.packages.$packageName){
                $self.packages.$packageName[^hash::create[]]
            }
#           iterate it and create packages
            ^packagesConfig.foreach[tag;config]{
                $package[^self.createPackage[$parsekitRepository;$config]]
                $index[^self.packages.$packageName._count[]]
                $self.packages.$packageName.$index[$package]
            }
        }

        ^if(!def $self.packages.$name){
            ^throw[PackageNotFoundException;PackageManager.p; Package with name '$name' not found ]
        }

    }

    $result[$self.packages.$name]
##


#------------------------------------------------------------------------------
#:param lockFile type LockFile
#
#:result hash of PackageInterface
#------------------------------------------------------------------------------
@packagesFromLock[lockFile]
    $packages[^hash::create[]]
    ^lockFile.packages.foreach[key;config]{
        $packages.$key[^self.createPackage[;$config]]
    }

    $result[$packages]
###


#------------------------------------------------------------------------------
#:param filePath type string
#
#:result PackageInterface
#------------------------------------------------------------------------------
@createRootPackage[filePath][result]
    $jsonFile[^JsonFile::create[$filePath]]
    $config[^jsonFile.read[]]
    $root[^RootPackage::create[$config.name]]
    $package[^self.configurePackage[$root;$config]]
    $result[$package]
###


#------------------------------------------------------------------------------
#:param repository type RepositoryInterface
#:param config type hash
#
#:result PackageInterface
#------------------------------------------------------------------------------
@createPackage[repository;config][result]
    $package[^self.configurePackage[^BasePackage::create[$config.name];$config]]
    $package.repository[$repository]
    $result[$package]
###


#------------------------------------------------------------------------------
#:param package type PackageInterface
#:param config type hash
#
#:result PackageInterface
#------------------------------------------------------------------------------
@configurePackage[package;config][result]

    $package.type[$config.type]
    $package.targetDir[^if(def $config.targetDir){$config.targetDir}{$config.name}]
    $package.sourceType[$config.sourceType]
    $package.sourceUrl[$config.sourceUrl]
    $package.sourceReference[$config.sourceReference]
    $package.distType[$config.distType]
    $package.distUrl[$config.distUrl]
    $package.distReference[$config.distReference]
    $package.releaseDate[$config.releaseDate]
    $package.autoload[^hash::create[$config.autoload]]
    $package.aliases[^hash::create[$config.aliases]]
    $package.docRoot[^if(def $config.docRoot){$config.docRoot}(!def $config.mainFileDir){www}]
    $package.mainFileDir[$config.mainFileDir]

    $package.uniqueName[${config.name}$config.version]
    $package.version[$config.version]
    $package.prettyVersion[$config.version]
    $package.stability[$config.stability]

    ^if($config.require is hash){
        ^config.require.foreach[packageName;constraint]{
            ^if(^packageName.pos[/] == -1){
#               custom requirements which is not package, like parser version on commandline tools
                ^continue[]
            }
            ^package.addRequire[$packageName;$constraint]
        }
    }

    ^rem{
    ^if($config.devRequire is hash){
        ^config.devRequire.foreach[packageName;constraint]{
            ^package.addDevRequire[
                $.name[$packageName]
                $.constraint[$constraint]
            ]
        }
    }
    }


    $result[$package]
###


#------------------------------------------------------------------------------
#:param searchString type string
#
#:result hash hash of assumptions
#------------------------------------------------------------------------------
@guessPackage[searchString][result]
    $result[^hash::create[]]
    $repositories[^self.repositoryManager.getRpositories[]]

    ^repositories.foreach[key;repository]{
        ^if($repository.searchPackages is junction){
            $tempAssumptions[^repository.searchPackages[$searchString]]

            ^tempAssumptions.foreach[packageName;repository]{
                $result.[^result._count[]][$packageName]
            }
        }
    }
###
