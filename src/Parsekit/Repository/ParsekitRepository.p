# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 18.03.16
# Time: 0:51
# To change this template use File | Settings | File Templates.

@CLASS
ParsekitRepository

@OPTIONS
locals

@BASE
BaseRepository

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
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
#
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
#
#:param packageName type string
#------------------------------------------------------------------------------
@notifyInstalls[packageName][result]
    $result[]
    $url[^RepositoryUtils:maskedUrl[${self.options.parsekitURL}$self.repoConfig.notify;$.packages[$packageName]]]
    $file[^curl:load[
        $.url[^taint[as-is][$url]]
        $.useragent[parsekit]
        $.timeout(20)
        $.ssl_verifypeer(0)
        $.followlocation(1)
    ]]
#   Add check of success information? for what?
###


#------------------------------------------------------------------------------
#:param searchString type string
#
#:result hash
#------------------------------------------------------------------------------
@searchPackages[searchString]
    $url[^RepositoryUtils:maskedUrl[${self.options.parsekitURL}$self.repoConfig.search;$.query[$searchString]]]

    $file[^curl:load[
        $.url[^taint[as-is][$url]]
        $.useragent[parsekit]
        $.timeout(20)
        $.ssl_verifypeer(0)
        $.followlocation(1)
    ]]

    $res[^json:parse[^taint[as-is][$file.text]]]

    ^if($res.protocol ne $self.options.protocol){
        ^throw[UnsopprtedProtocolExeception;;Protocol $res.protocol not equal $self.options.protocol]
    }

    $result[^hash::create[]]
    ^res.packages.foreach[key;package]{
        $result.[$package.name][$self]
    }
###
