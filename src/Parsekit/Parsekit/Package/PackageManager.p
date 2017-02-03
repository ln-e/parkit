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
#:param versionParser type Parsekit/Semver/VersionParser
#------------------------------------------------------------------------------
@create[repositoryManager;versionParser]
    $self.versionParser[$versionParser]
    $self.repositoryManager[$repositoryManager]
    $self.packages[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param name type string
#:param minStability type string
#
#:result hash of PackageInterface
#------------------------------------------------------------------------------
@getPackage[name;minStability][result]
#   TODO get list of repositories instead of direct access to parsekitRepository

    $minStabilityPriority[$self.versionParser.stabilities.[^self.versionParser.normalizeStability[$minStability]]]
    $minStabilityPriority[^minStabilityPriority.int($self.versionParser.stabilities.dev)]

    $parsekitRepository[$self.repositoryManager.parsekitRepository]

#   TODO pass root package to getRepositories[] ?
    $repositories[^self.repositoryManager.getRepositories[]]
    ^repositories.foreach[key;repository]{
        ^if(!^repository.hasPackage[$name]){
            ^continue[]
        }

#       if package is not listed yet
        ^if(!def $self.packages.$name){
            $loadedConfig[^repository.loadPackages[$name]]

            ^loadedConfig.foreach[packageName;packagesConfig]{
                ^if(!def $self.packages.$packageName){
                    $self.packages.$packageName[^hash::create[]]
                }

#               iterate it and create packages
                ^packagesConfig.foreach[tag;config]{
                    ^if($repository is SystemRepository){
                        $package[^self.createSystemPackage[$repository;$config]]
                    }{
                        $package[^self.createPackage[$repository;$config]]
                    }

                    $packageStabilityPriority[$self.versionParser.stabilities.[$package.stability]]

#                   Adds package only if stability is in bounds.
                    ^if($packageStabilityPriority <= $minStabilityPriority){
                        $index[^self.packages.$packageName._count[]]
                        $self.packages.$packageName.$index[$package]
                    }
                }
            }

            ^if(!def $self.packages.$name){
                ^throw[PackageNotFoundException;;Package '$name' ^if(def $minStability){with minimum stability '$minStability' }not found ]
            }

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
#:param repository type RepositoryInterface
#:param config type hash
#
#:result PackageInterface
#------------------------------------------------------------------------------
@createSystemPackage[repository;config][result]
    $package[^SystemPackage::create[$config.name;$config.version]]
    $package.repository[$repository]
    $result[$package]
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
    $package.devAutoload[^hash::create[$config.devAutoload]]
    $package.aliases[^hash::create[$config.aliases]]
    $package.docRoot[^if(def $config.docRoot){^config.docRoot.trim[both;/\]}{www}]
    $package.minimumStability[^if(def $config.minimumStability){^self.versionParser.normalizeStability[$config.minimumStability]}{dev}]

    ^if(def $config.version){
        $package.version[$config.version]
        $package.normilizedVersion[^self.versionParser.normalize[$config.version]]
        $package.stability[^self.versionParser.normalizeStability[^self.versionParser.parseStability[$package.normilizedVersion]]]
        $package.uniqueName[${package.name}$package.version]
    }

    ^if($config.require is hash){
        ^config.require.foreach[packageName;constraint]{
            ^if(^packageName.pos[/] == -1){
#               custom requirements which is not package, like parser version on commandline tools
#                ^continue[]
            }
            ^package.addRequire[$packageName;$constraint]
        }
    }

    ^if($config.devRequire is hash){
        ^config.devRequire.foreach[packageName;constraint]{
            ^package.addDevRequire[$packageName;$constraint]
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
