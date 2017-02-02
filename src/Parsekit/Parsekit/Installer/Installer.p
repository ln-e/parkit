# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 28.04.16
# Time: 23:30
# To change this template use File | Settings | File Templates.

@CLASS
Installer

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param driverManager type DriverManager
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[driverManager;filesystem]
    $self.driverManager[$driverManager]
    $self.filesystem[$filesystem]
    $self.autoloadData[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param lockFile type LockFile
#:param packages type hash Actual packages
#:param rootPackage type RootPackage
#:param options type hash
#
#:result hash updated packages
#------------------------------------------------------------------------------
@update[lockFile;packages;rootPackage;options][result]
    ^if(!-d '/$DI:vaultDirName'){
        ^self.createVault[]
    }

    $packagesToUpdate[^hash::create[]]
    $packagesToRemove[^hash::create[]]
    ^packages.foreach[packageName;package]{
        ^if(!($package is SystemPackage) && ^lockFile.addPackage[$package]){
            $packagesToUpdate.$packageName[$package]
        }
    }

    ^lockFile.packages.foreach[name;package]{
        ^if(!($package is SystemPackage) && !^packages.contains[$name]){
            $packagesToRemove.$name[$package]
        }
    }

    $preferDist($options is hash && ^options.contains[prefer-dist])
    $failedInstall[^self.install[$packagesToUpdate;$.preferDist($preferDist)]]
    $failedUninstall[^if(^failedInstall._count[] == 0){
        ^self.uninstall[$packagesToRemove]
    }{ ^hash::create[] }]
    ^self.dumpClassPath[$rootPackage;$packages]

#   Generates text representation. TODO replace by direct write to some outputinterface!
    $info[]
    ^if(^packagesToUpdate._count[] == 0 && ^packagesToRemove._count[] == 0 ){
        $info[${info}  Nothing to install or update. All package is up to date.^#0A]
    }(^failedInstall._count[] == 0 && ^failedUninstall._count[] == 0){
        $info[${info}  Dependencies was updated. ^#0A]

        ^if(^packagesToUpdate._count[] > 0){
            $info[$info ^taint[^#0A]  Updated/installed packages: ^#0A]
            ^packagesToUpdate.foreach[name;package]{
                $info[$info    - $name^: $package.version^#0A]
            }
        }

        ^if(^packagesToRemove._count[] > 0){
            $info[$info  Removed packages:^#0A]
            ^packagesToRemove.foreach[name;package]{
                ^if(^lockFile.remove[$package]){
                    $info[$info    - $name^: $package.version^#0A]
                }
            }
        }
    }{
        $info[${info}ERR!ERR!^#0AERR!ERR!^#0AERR!ERR!^#0A]

        ^if(^failedInstall._count[]){
            $info[$info^#0A  Failed to install or update next packages: ^#0A]

            ^failedInstall.foreach[name;package]{
               $info[$info    - $name^#0A]
            }
        }

        ^if(^failedUninstall._count[]){
            $info[$info^#0A  Failed to remove next packages: ^#0A]

            ^failedUninstall.foreach[name;package]{
               $info[$info    - $name^#0A]
            }
        }
    }

    $result[
        $.updated[$packagesToUpdate]
        $.uninstalled[$packagesToRemove]
        $.failedInstall[$failedInstall]
        $.faileduninstall[$failedUninstall]
        $.info[$info]
    ]
###


#------------------------------------------------------------------------------
#:param packages type hash
#:param options type hash
#
#:result hash of failed packages
#------------------------------------------------------------------------------
@install[packages;options][result]
    $result[^hash::create[]]
    ^packages.foreach[key;package]{
        ^if(!^self.driverManager.mount[/$DI:vaultDirName/$package.targetDir;$package;$options]){
            $result.$key[$package]
            ^break[]
            ^rem[ TODO replace boolean indication by throwing exception ]
        }
        ^if($package.repository.notifyInstalls is junction){
            ^package.repository.notifyInstalls[$package.name]
        }
    }
###


#------------------------------------------------------------------------------
#:param packages type hash
#:param options type hash
#
#:result hash of failed packages
#------------------------------------------------------------------------------
@uninstall[packages;options][result]
    $result[^hash::create[]]
    ^packages.foreach[key;package]{
        ^if(!^self.driverManager.unmount[/$DI:vaultDirName/$package.targetDir;$package;$options]){
            $result.$key[$package]
            ^break[]
            ^rem[ TODO replace boolean indication by throwing exception ]
        }
    }
###


#------------------------------------------------------------------------------
#Dumps class path accroding to packages settings
#
#:param rootPackage type RootPackage
#:param packages type hash
#------------------------------------------------------------------------------
@dumpClassPath[rootPackage;packages][result]

    $mergedPackages[
        $.root[$rootPackage]
    ]

#   TODO warning. What if root is another package ?
    ^mergedPackages.add[$packages]

    $docRoot[^if(!^rootPackage.dynamicDocRoot.bool(false)){/}^Als/Path/Path:dirname[^Als/Path/Path:relative[$rootPackage.docRoot;$DI:vaultDirName]]/]

    $self.autoloadData[
        $.namespaces[^hash::create[]]
        $.namespacesMap[^hash::create[]]
        $.files[^hash::create[]]
        $.classpath[
            $.0[${docRoot}$DI:vaultDirName/]
        ]
    ]

    ^mergedPackages.foreach[name;package]{
        ^if($package is RootPackage){
            $basePath[$docRoot]
            $installationBasePath[/]
            $addMap(true)
        }{
            $basePath[${docRoot}$DI:vaultDirName/${package.targetDir}/]
            $installationBasePath[/$DI:vaultDirName/${package.targetDir}/]
            $addMap(false)
        }

        ^if($package.devAutoload is hash){
            ^self._processAutoload[$package.devAutoload;$basePath;$installationBasePath;$docRoot;$addMap]
        }
        ^if($package.autoload is hash){
            ^self._processAutoload[$package.autoload;$basePath;$installationBasePath;$docRoot;$addMap]
        }
    }

    $string[#Do not edit this file. It is autogenerated by parsekit.
^@auto[]
^$parsekitClasspath[
    ^$.namespaces[
        ^^hash::create[
            ^self.autoloadData.namespaces.foreach[key;value]{^$.[$key][$value]}[^#0A            ]]
    ]
    ^$.namespacesMap[
        ^^hash::create[
            ^self.autoloadData.namespacesMap.foreach[key;value]{^$.[$key][$value]}[^#0A            ]
        ]
    ]
    ^$.classpath[^^table::create{path
^self.autoloadData.classpath.foreach[i;val]{$val}[^#0A]
    }]
    ^$.files[
        ^^hash::create[
            ^self.autoloadData.files.foreach[key;value]{^$.[$key][$value]}[^#0A]
        ]
    ]
]

^^if(^$MAIN:CLASS_PATH is table){
    ^^MAIN:CLASS_PATH.join[^$parsekitClasspath.classpath]
}{
    ^$MAIN:CLASS_PATH[^$parsekitClasspath.classpath]
}

^^parsekitClasspath.files.foreach[key^;path]{
    ^^use[^$path]
}
^###


^@autouse^[className^]
    ^^if(^^parsekitClasspath.namespaces.contains^[^$className^])^{
        ^^use^[^$parsekitClasspath.namespaces.^$className^]
    ^}(def ^$parsekitClasspath.namespacesMap && ^^className.pos^[/^] != -1)^{
        ^^parsekitClasspath.namespacesMap.foreach^[namespace^;path^]^{
            ^^if(^^className.pos^[^$namespace^] == 0)^{
                ^^use^[^$path^^className.mid(^^namespace.length^[^]).p^]
            ^}
        ^}
    ^}^{
        ^^use^[^$^{className^}.p^]
    ^}
^###
]
    ^string.save[/$DI:vaultDirName/classpath.p]
###


#------------------------------------------------------------------------------
#Process autoload section to populate self.autoloadData with autoload data
#
#:param autoload type hash autoload section from config (autoload or devAutoload)
#:param basePath type string base path for package
#:param installationBasePath type string base path during installation (when document root is differ from execution document root)
#:param docRoot type string
#:param addMap type bool add namespace to map for runtime class search
#------------------------------------------------------------------------------
@_processAutoload[autoload;basePath;installationBasePath;docRoot;addMap]

    ^self.autoloadData.files.add[^hash::create[$autoload.files]]

    ^if($autoload.classpath is hash){
        ^autoload.classpath.foreach[key;path]{
            $path[^taint[as-is][^path.trim[left;/]]]
            $self.autoloadData.classpath.[^self.autoloadData.classpath._count[]][${basePath}$path/]
        }
    }

    ^if($autoload.nestedClasspath is hash){
        ^autoload.nestedClasspath.foreach[key;path]{
#           Handle as usual classpath
            $path[^taint[as-is][^path.trim[left;/]]]
            $self.autoloadData.classpath.[^self.autoloadData.classpath._count[]][${basePath}$path/]
#           And iterate all sub dirs
            $hash[^self.filesystem.subDirs[${installationBasePath}$path]]
            ^hash.foreach[i;dir]{
                $self.autoloadData.classpath.[^self.autoloadData.classpath._count[]][${docRoot}^dir.trim[left;/]]
            }
        }
    }

#   For namespace we pre-search classes and build map.
    ^if($autoload.namespace is hash){
        ^autoload.namespace.foreach[namespacePrefix;path]{
            $path[^taint[as-is][^path.trim[left;/]]]
            ^if($addMap){
                $self.autoloadData.namespacesMap.$namespacePrefix[${docRoot}$path]
            }
            $searchDir[${installationBasePath}$path]
            $files[^self.filesystem.subFiles[$searchDir](false)(true)]

            ^files.foreach[key;value]{
                $className[$namespacePrefix^value.replace[$searchDir;]]
                $className[^className.match[\.p^$][i]{}]
                $file[^file::load[text;$value]]
                ^if(^file.text.match[^@class\n$className][giUn] > 0){
                    $value[^value.trim[left;/]]
                    $self.autoloadData.namespaces.[$className][${docRoot}$value]
                }
            }
        }
    }
###


#------------------------------------------------------------------------------
# Attempts to create vault directory
#------------------------------------------------------------------------------
@createVault[]
    ^self.filesystem.createDir[/$DI:vaultDirName]
###
