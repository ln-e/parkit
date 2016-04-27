# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 23.04.16
# Time: 22:41
# To change this template use File | Settings | File Templates.

@CLASS
DI

@OPTIONS
locals

@USE
Package/PackageManager.p
Repository/RepositoryManager.p
Resolver/Resolver.p
Version/Comparator.p
Version/VersionParser.p
Version/Semver.p


#Dummiest mock for future di container implementation
#Sorry for name it DI, but someday we replace it by real IoC-container, I promise.
@auto[]
    $self.repositoryManager[^RepositoryManager::create[]]
    $self.packageManager[^PackageManager::create[$self.repositoryManager]]
    $self.versionParser[^VersionParser::create[]]
    $self.comparator[^Comparator::create[]]
    $self.semver[^Semver::create[$self.versionParser;$self.comparator]]
    $self.resolver[^Resolver::create[$self.packageManager;$self.semver]]
###


@create[]
###


@static:GET_DEFAULT[key][result]
    ^if(!def $self.$key){
        ^throw[service.unknown;container.p;Service $key not found]
    }
    $result[$self.$key]
###
