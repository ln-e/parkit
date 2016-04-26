# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 21.03.16
# Time: 9:06
# To change this template use File | Settings | File Templates.

@CLASS
VersionParser

@OPTIONS
locals

@USE
Constraint/MultiConstraint.p

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
$self.modifierRegex[[._-]?(?:(stable|beta|b|RC|alpha|a|patch|pl|p)((?:[.-]?\d+)*+)?)?([.-]?dev)?^$]

$self.stabilities[^table::create{stability
stable
RC
beta
alpha
dev
}]

$self.implodedStabilities[^self.stabilities.menu{$self.stabilities.stability}[|]]

###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
###


#------------------------------------------------------------------------------
#Returns a stability
#:param version type string String representation on version
#
#:result string
#------------------------------------------------------------------------------
@parseStability[version][result]
    $version[^version.match[#.*^$][i]{}] ^rem[Stripped out #hash of version]

    ^version.match[$self.modifierRegex][i]{
        ^if($match.3 eq dev){
            $result[dev]
        }($match.1 eq beta || $match.1 eq b){
            $result[beta]
        }($match.1 eq alpha || $match.1 eq a){
            $result[alpha]
        }($match.1 eq rc){
            $result[rc]
        }{
            $result[stable]
        }
    }{ ^throw[couldn't parse version]}
###


#------------------------------------------------------------------------------
#:param stability type string
#
#:result string
#------------------------------------------------------------------------------
@normalizeStability[stability][result]
    $result[^stability.lower[]]

    ^if($result eq rc){$result[RC]}
###


#------------------------------------------------------------------------------
#:param branchName type string
#
#:result string
#------------------------------------------------------------------------------
@normalizeBranch[branchName][result]

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
#
#:result string
#------------------------------------------------------------------------------
@parseNumericAliasPrefix[branchName][result]
    ^branchName.match[^^((\d++\.)*\d++)(?:\.x)?-dev^$][i]{
        $result[${match.1}.]
    }{
        $result(false)
    }
###


#------------------------------------------------------------------------------
# TODO probably broken method
#:param version type string
#
#:result string
#------------------------------------------------------------------------------
@normalize[version][result]

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
            $matches[^version.match[^^v?(\d{1,5})(\.\d+)?(\.\d+)?(\.\d+)?$self.modifierRegex^$][i]]
            ^if(def $matches){
                $version[]
                ^for[i](1;4){
                    $version[${version}^if(def $matches.$i)[$matches.$i][.0]]
                }
                $index(5)
            }{
                $matches[^version.match[^^v?(\d{4}(?:[.:-]?\d{2}){1,6}(?:[.:-]?\d{1,3})?)$self.modifierRegex^$]]
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
        ^throw[UnexpectedValueException;VersionParser.p;Invalid version string $fullVersion]
    }
###


#------------------------------------------------------------------------------
#:param constraints type string
#------------------------------------------------------------------------------
@parseConstraints[constraints]
    $prettyConstraint[$constraints]
    $constraints[^constraints.trim[]]

    $matches[^constraints.match[^^([^^,\s]*?)@($self.implodedStabilities)^$][i]]
    ^if($matches){
        $constraints[^if(!def $matches.1){*}{$matches.1}]
    }

    $matches[^constraints.match[^^(dev-[^^,\s@]+?|[^^,\s@]+?\.x-dev)#.+^$][i]]
    ^if($matches){
        $constraints[$matches.1]
    }

    $orConstraints[^rsplit[$constraints;(\s*\|\|?\s*)]]
    $orConstraints[^orConstraints.flip[]]
    ^orConstraints.offset(3)
    $orConstraints[$orConstraints.fields]

    $orGroups[^hash::create[]]
    ^orConstraints.foreach[key;constraint]{
        $andConstraints[^rsplit[$constraint;(?<!^^|as|[=>< ,]) *(?<!-)[, ](?!-) *(?!,|as|^$)]]
        $andConstraints[^andConstraints.flip[]]
        ^andConstraints.offset(3)
        $andConstraints[$andConstraints.fields]

        ^if(^andConstraints._count[] > 1){
            $constraintObjects[^hash::create[]]
            ^andConstraints.foreach[j;andConstraint]{
                $parsedConstraints[^self.parseConstraint[$andConstraint]]
                ^parsedConstraints.foreach[k;parsedConstraint]{
                    $index[^constraintObjects._count[]]
                    $constraintObjects.$index[$parsedConstraint]
                }
            }
        }{
            $constraintObjects[^self.parseConstraint[^andConstraints._at(0)]]
        }

        $constraint[^if(^constraintObjects._count[] == 1){$constraintObjects[0]}{^MultiConstraint::create[$constraintObjects]}]
        $index[^orGroups._count[]]
        $orGroups.$index[$constraint]
    }

# precalucalation for if else params
    ^if(2 == ^orGroups._count[]){
        $a[^orGroups.0.GET[]]
        $b[^orGroups.1.GET[]]
        $posA[^a.pos['<'](4)]
        $posB[^b.pos['<'](4)]
    }

    ^if(1 == ^orGroups._count[]){
        $constraint[$orGroups.0]
    }(2 == ^orGroups._count[]
# parse the two OR groups and if they are contiguous we collapse
# them into one constraint
      && $orGroups.0 is MultiConstraint
      && $orGroups.1 is MultiConstraint
      && ^a.mid(0;3) eq '[>=' && ($posA != -1)
      && ^b.mid(0;3) eq '[>=' && ($posB != -1)
      && ^a.mid($posA + 2;-1) == ^b.mid(4;$posB - 5)
        ){
            $constraint[^MultiConstraint::create[
                $.0[^Constraint::create['>=';^a.mid(4;$posA - 5)]]
                $.1[^Constraint::create['<';^b.mid($posB + 2;-1)]]
            ]]
        }
    }{
        $constraint[^MultiConstraint::create[$orGroups](false)]
    }

    $constraint.prettyString[$prettyConstraint]

    $result[$constraint]

    ^dstop[$constraint]

###


#:param constraint type string
#
#:result hash
@parseConstraint[constraint][result]

    $matches[^constraint.match[^^([^^,\s]+?)@($self.implodedStabilities)^$][i]]
    ^if($matches){
        $constraint[$matches.1]

        ^if($matches.2 ne 'stable'){
            $stabilityModifier[$matches.2]
        }
    }

    ^if(^constraint.match[^^v?[xX*](\.[xX*])*^$][i]){
        $result[^EmptyConstraint::create[]]
    }

    $versionRegex[v?(\d++)(?:\.(\d++))?(?:\.(\d++))?(?:\.(\d++))?$self.modifierRegex^(?:\+[^^\s]+)?]



# Tilde Range
#
# Like wildcard constraints, unsuffixed tilde constraints say that they must be greater than the previous
# version, to ensure that unstable instances of the current version are allowed. However, if a stability
# suffix is added to the constraint, then a >= match on the current version is used instead.
    $matches[^constraint.match[^^~>?$versionRegex^$][i]]
    ^if(!def $result && $matches){

        ^if(^constraint.mid(0;2) eq '~>'){
            ^throw[UnexpectedValue;VersionParser.p;Invalid operator "~>", you probably meant to use the "~" operator]
        }

        ^if($matches.4 && '' ne $matches.4){
            $position[4]
        }($matches.3 && '' ne $matches.3){
            $position[3]
        }($matches.2 && '' ne $matches.2){
            $position[2]
        }{
            $position[1]
        }

        $stabilitySuffix[]
        ^if($matches.5){
            $stabilitySuffix[-$this.expandStability[$matches.5]^if($matches.6){$matches.6}]
        }
        ^if($matches.7){
            $stabilitySuffix[${stabilitySuffix}-dev]
        }
        ^if(!$stabilitySuffix){
            $stabilitySuffix[-dev]
        }

        $lowVersion[^self.manipulateVersionString[$matches;$position;0]$stabilitySuffix]
        $lowerBound[^Constraint::create['>=';$lowVersion]]

        $highPosition[max(1, $position - 1)]
        $highVersion[^self.manipulateVersionString[$matches;$highPosition;1]-dev]
        $upperBound[^Constraint::create['<';$highVersion]]

        $result[
          $.0[$lowerBound]
          $.1[$upperBound]
        ]
    }



# Caret Range
#
# Allows changes that do not modify the left-most non-zero digit in the [major, minor, patch] tuple.
# In other words, this allows patch and minor updates for versions 1.0.0 and above, patch updates for
# versions 0.X >=0.1.0, and no updates for versions 0.0.X
    $matches[^constraint.match[^^\^^$versionRegex^(^$)][i]]
    ^if(!def $result && $matches){

        ^if('0' ne $matches.1 || '' eq $matches.2){
            $position[1]
        }('0' ne $matches.2 || '' eq $matches.3){
            $position[2]
        }{
            $position[3]
        }

# Calculate the stability suffix
        $stabilitySuffix[]
        ^if($matches.5 && !def $matches.7){
            $stabilitySuffix['-dev']
        }

        $tmp[${constraint}$stabilitySuffix]
        $lowVersion[^self.normalize[^tmp.mid(1)]]
        $lowerBound[^Constraint::create['>=';$lowVersion]]
# For upper bound, we increment the position of one more significance,
# but highPosition = 0 would be illegal
        $highVersion[^self.manipulateVersionString[$matches;$position;1]-dev]
        $upperBound[^Constraint::create['<';$highVersion]]

        $result[
            $.0[$lowerBound]
            $.1[$upperBound]
        ]
    }



#X Range
#
#Any of X, x, or * may be used to "stand in" for one of the numeric values in the [major, minor, patch] tuple.
#A partial version range is treated as an X-Range, so the special character is in fact optional.
    $matches[^constraint.match[^^v?(\d++)(?:\.(\d++))?(?:\.(\d++))?(?:\.[xX*])++^$][i]]
    ^if(!def $result && $matches){

        ^if($matches.3 && '' ne $matches.3){
            $position[3]
        }($matches.2 && '' ne $matches.2){
            $position[2]
        }{
            $position[1]
        }

        $lowVersion[^self.manipulateVersionString[$matches;$position]-dev']
        $highVersion[^self.manipulateVersionString[$matches;$position;1]-dev']
        ^if($lowVersion eq '0.0.0.0-dev'){
            $result[
                $.0[^Constraint::create['<';$highVersion]]
            ]
        }{
            $result[
                $.0[^Constraint::create['>=';$lowVersion]]
                $.1[^Constraint::create['<';$highVersion]]
            ]
        }
    }

#Hyphen Range
#
#Specifies an inclusive set. If a partial version is provided as the first version in the inclusive range,
#then the missing pieces are replaced with zeroes. If a partial version is provided as the second version in
#the inclusive range, then all versions that start with the supplied parts of the tuple are accepted, but
#nothing that would be greater than the provided tuple parts.
    $matches[^constraint.match[^^(?P<from>$versionRegex) +- +(?P<to>$versionRegex)(^$)][i]]
    ^if(!def $result && $matches){

# Calculate the stability suffix
        $lowStabilitySuffix[]
        ^if(!$matches.6 && !$matches.8){
            $lowStabilitySuffix[-dev]
        }
        $lowVersion[^self.normalize[$matches.from]]
        $lowerBound[^Constraint::create['>=';${lowVersion}$lowStabilitySuffix]]

        ^if((!^self.emptyX[$matches.11] && !^self.emptyX[$matches.12]) || !$matches.14 || !$matches.16){
            $highVersion[^self.normalize[$matches.to]]
            $upperBound[^Constraint::create['<=';$highVersion]]
        }{
            $highMatch[
                $.0[]
                $.1[$matches.10]
                $.2[$matches.11]
                $.3[$matches.12]
                $.4[$matches.13]
            ]
            $pos[^if(^self.emptyX[$matches.11]){1}{2}]
            $highVersion[^self.manipulateVersionString[$highMatch;$pos;1]-dev]
            $upperBound[^Constraint::create['<';$highVersion]]
        }

        $result[
            $.0[$lowerBound]
            $.1[$upperBound]
        ]
    }


#Basic Comparators
    $matches[^constraint.match[^^(<>|!=|>=?|<=?|==?)?\s*(.*)][]]
    ^if(!def $result && $matches){

        $version[^self.normalize[$matches.2]]

        ^if(def $stabilityModifier && ^self.parseStability[$version] eq stable){
            $version[${version}-$stabilityModifier]
        }('<' eq $matches.1 || '>=' eq $matches.1){
            $lowerTmp[^matches.2.lower[]]

            ^if(^lowerTmp.match[-$modifierRegex^$][n] > 0){
                ^if(^matches.2.mid(0;4) ne 'dev-'){
                    $version[${version}-dev]
                }
            }
        }

        $result[
            $.0[^Constraint::create[^if(def $matches.1){$matches.1}{=};$version]]
        ]
    }

    $message[Could not parse version constraint $constraint]

    ^if(!$result){
        ^throw[UnexpectedValueException;VersionParser.p;$message]
    }


###


#:param x type string
#
#:result bool
@emptyX[x][result]
    ^if($x == 0 || $x eq '0'){
        $result(false)
    }{
        $result(def $x)
    }
###
