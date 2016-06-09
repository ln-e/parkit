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
#------------------------------------------------------------------------------
@getPackages[name][result]
#   TODO get list of repositories instead of direct access to parsekitRepository
    $parsekitRepository[$self.repositoryManager.parsekitRepository]

    ^if(!def $parsekitRepository.lazyPackages.$name){
        ^throw[lazypackagenotfound;PackageManager.p; Package with name '$name' not found ]
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


#:param lockFile type LockFile
@packagesFromLock[lockFile]
    $packages[^hash::create[]]
    ^lockFile.packages.foreach[key;config]{
        $packages.$key[^self.createPackage[;$config]]
    }

    $result[$packages]
###


#------------------------------------------------------------------------------
#:param config type hash
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
    $package.classPath[^if($config.classPath is hash){$config.classPath}{^hash::create[]}]

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

    ^rem{^if($config.devRequire is hash){
        ^config.devRequire.foreach[packageName;constraint]{
# ho ho ho but we should have here PackageInterface ?
            ^package.addDevRequire[
                $.name[$packageName]
                $.constraint[$constraint]
            ]
        }
    }}

#    $package.requires[$config.requires]
#    $package.devRequires[$config.devRequires]


    $result[$package]
###
