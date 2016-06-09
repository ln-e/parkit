# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:51
# To change this template use File | Settings | File Templates.

@CLASS
ParsekitRepository

@USE
BaseRepository.p
RepositoryUtils.p
Utils/JsonFile.p

@OPTIONS
locals

@BASE
BaseRepository

@auto[]
###


#------------------------------------------------------------------------------
#Dynamic constructor
#------------------------------------------------------------------------------
@create[]
    $self.repoConfig[]
    $self.options[
        $.parsekitURL[http://parsekit.ru]
        $.providerURL[http://parsekit.ru/packages.json]
        $.protocol[1]
    ]
    $self.lazyPackages[^hash::create[]]

    ^init[]
###


#------------------------------------------------------------------------------
#Makes all initializations, such as loading repository json data
#------------------------------------------------------------------------------
@init[][result]
    $packagesJsonFile[^JsonFile::create[$self.options.providerURL]]
    $self.repoConfig[^packagesJsonFile.read[]]
    ^validateConfig[]

    ^repoConfig.packages.foreach[packageName;packageInfo]{
#       ^self.addPackage[^PackageFactory:createPackage[$packageName;$packageInfo]]
        $self.lazyPackages.$packageName[$packageInfo]
    }

    ^repoConfig.providers.foreach[providerMask;providerConfig]{
        ^self.loadProvider[${self.options.parsekitURL}^RepositoryUtils:maskedUrl[$providerMask;$providerConfig]]
    }

###


#------------------------------------------------------------------------------
#Loaded from the separated json files ~(providers) available packages
#
#:param url param string URL where provider is located (may be remote or local)
#------------------------------------------------------------------------------
@loadProvider[url][result]
    $providerJsonFile[^JsonFile::create[$url]]
    $providerJson[^providerJsonFile.read[]]

    ^providerJson.providers.foreach[packageName;packageConfig]{
        $self.lazyPackages.$packageName[$packageConfig]
    }
###


#------------------------------------------------------------------------------
#:param packageName param
#:result hash
#------------------------------------------------------------------------------
@loadPackages[packageName][result]
    $url[${self.options.parsekitURL}/p/${packageName}.json]
    $packagesJsonFile[^JsonFile::create[$url]]
    $packagesJson[^packagesJsonFile.read[]]

    $result[$packagesJson.packages]
###


#------------------------------------------------------------------------------
#Validates main repository configuration by protocol version.
#------------------------------------------------------------------------------
@validateConfig[][result]
$[

Package.json version used differ protocol version.
Update your parsekit to latest version:

^$ ./parserkit selfupdate
]
    ^if($self.repoConfig.protocol != $self.options.protocol){
        ^throw[protocol.version.differ;ParsekitRepository.p;$errorText]
    }
###


#------------------------------------------------------------------------------
#Validates main repository configuration by protocol version.
#------------------------------------------------------------------------------
@notifyInstalls[packageName]
    $url[^RepositoryUtils:maskedUrl[${self.options.parsekitURL}$self.repoConfig.notify;$.packages[$packageName]]]
    $result[^curl:load[
        $.url[^taint[as-is][$url]]
        $.useragent[parsekit]
        $.timeout(20)
        $.ssl_verifypeer(0)
        $.followlocation(1)
    ]]
###
