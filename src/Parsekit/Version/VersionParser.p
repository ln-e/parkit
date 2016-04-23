# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 21.03.16
# Time: 9:06
# To change this template use File | Settings | File Templates.

@CLASS
VersionParser

@OPTIONS
locals

#------------------------------------------------------------------------------
#Static constructor
#------------------------------------------------------------------------------
@auto[]

# Regex to match pre-release data (sort of).
#
# Due to backwards compatibility:
#  - Instead of enforcing hyphen, an underscore, dot or nothing at all are also accepted.
#  - Only stabilities as recognized are allowed to precede a numerical identifier.
#  - Numerical-only pre-release identifiers are not supported.
#
#                        |--------------|
# [major].[minor].[patch] -[pre-release] +[build-metadata]
$VersionParser:modifierRegex[[._-]?(?:(stable|beta|b|RC|alpha|a|patch|pl|p)((?:[.-]?\d+)*+)?)?([.-]?dev)?^$];

$VersionParser:stabilities[^table::create{stability
stable
RC
beta
alpha
dev
}];
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#Returns a stability
#:param version type string String representation on version
#------------------------------------------------------------------------------
@static:parseStability[version][result]
#Stripped out #hash of version
    $version[^version.match[#.*^$][i]{}]

    ^version.match[$VersionParser:modifierRegex][i]{
        $result[stable]

        ^if($match.3 eq dev){
            $result[dev]
        }

        ^if($match.1 eq beta || $match.1 eq b){
            $result[beta]
        }

        ^if($match.1 eq alpha || $match.1 eq a){
            $result[alpha]
        }

        ^if($match.1 eq rc){
            $result[rc]
        }

    }{ ^throw[couldn't parse version]}
###


#------------------------------------------------------------------------------
#:param stability type string
#:result string
#------------------------------------------------------------------------------
@static:normalizeStability[stability][result]
    $result[^stability.lower[]]

    ^if($result eq rc){$result[RC]}
###


#------------------------------------------------------------------------------
#:param branchName type string
#:result string
#------------------------------------------------------------------------------
@static:normalizeBranch[branchName][result]

    $name[^branchName.trim[]]

    $master[
        $.master[]
        $.trunk[]
        $.default[]
    ]

    ^if(^master.contains[$name]){
        $result[^VersionParser:normalize[$name]]
    }{
        ^name.match[^^v?(\d++)(\.(?:\d++|[xX*]))?(\.(?:\d++|[xX*]))?(\.(?:\d++|[xX*]))?^$][i]{
            $version[]
            $repl[^table::create[nameless]{*	x}]
            ^for[i](1;4){
                ^if(def $match.$i){
                    $version[$version^match.$i.replace[$repl]]
                }{
                    $version[${version}.x]
                }
            }
            $version[^version.lower[]]

            $result[^version.replace[^table::create[nameless]{x	9999999}]-dev]
        }{
            $result[dev-$name]
        }
    }
###


#------------------------------------------------------------------------------
#:param branchName type string
#:result string
#------------------------------------------------------------------------------
@static:parseNumericAliasPrefix[branchName][result]
    ^branchName.match[^^((\d++\.)*\d++)(?:\.x)?-dev^$][i]{
        $result[${match.1}.]
    }{
        $result(false)
    }
###


#------------------------------------------------------------------------------
# TODO probably broken method
#:param version type string
#------------------------------------------------------------------------------
@static:normalize[version][result]

    $result[qwe]

    $version[^version.trim[]]

    $fullVersion[$version]

# strip off aliasing
    $matches[^version.match[^^([^^,\s]+) +as +([^^,\s]+)^$][i]]
    ^if(def $matches){
        $version[$match.1]
    }

# strip off build metadata
    $matches[^version.match[^^([^^,\s+]+)\+[^^\s]+^$][i]]
    ^if(def $matches){
        $version[$matches.1]
    }

# match master-like branches

    $matches[^version.match[^^(?:dev-)?(?:master|trunk|default)^$][i]]
    ^if(def $matches){
        $result[9999999-dev]
    }{
# add somehow lower to if's version mid
        ^if('dev-' eq ^version.mid(0;4)){
            $result[dev-^version.mid(4)]
        }{
            $matches[^version.match[^^v?(\d{1,5})(\.\d+)?(\.\d+)?(\.\d+)?$VersionParser:modifierRegex^$][i]]
            ^if(def $matches){
                $version[]
                ^for[i](1;4){
                    $version[${version}^if(def $matches.$i)[$matches.$i][.0]]
                }
                $index(5)
            }{
                $matches[^version.match[^^v?(\d{4}(?:[.:-]?\d{2}){1,6}(?:[.:-]?\d{1,3})?)$VersionParser:modifierRegex^$]]
                ^if($matches){
                    $tmp[$matches.1]
                    $version[^tmp.match[\D][g]{.}]
                    $index(2)
                }
            }

            ^if(def $index){
# TODO expand stability!
                $result[$version]
            }{

                $matches[^version.match[(.*?)[.-]?dev^$][i]]

                ^if(def $matches){
                    $result[^VersionParser:normalizeBranch[$matches.1]]
                }

            }

        }
    }

    ^if(!def $result){
        ^throw[Invalid version string $fullVersion]
    }
###
