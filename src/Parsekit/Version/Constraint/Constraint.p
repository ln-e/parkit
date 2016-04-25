# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 25.04.16
# Time: 1:08
# To change this template use File | Settings | File Templates.

@CLASS
Constraint

@OPTIONS
locals

@USE
ConstraintInterface.p

@BASE
ConstraintInterface

@auto[]
    $self.OP_EQ(0)
    $self.OP_LT(1)
    $self.OP_LE(2)
    $self.OP_GT(3)
    $self.OP_GE(4)
    $self.OP_NE(5)

    $self.opString[
        $.'='($self.OP_EQ)
        $.'=='($self.OP_EQ)
        $.'<'($self.OP_LT)
        $.'<='($self.OP_LE)
        $.'>'($self.OP_GT)
        $.'>='($self.OP_GE)
        $.'<>'($self.OP_NE)
        $.'!='($self.OP_NE)
    ]

    $self.opInt[
        $.${self.OP_EQ}['==']
        $.${self.OP_LT}['<']
        $.${self.OP_LE}['<=']
        $.${self.OP_GT}['>']
        $.${self.OP_GE}['>=']
        $.${self.OP_NE}['!=']
    ]

###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[operator;version]
    ^if(!^self.opString.contains[$operator]){
        ^throw[invalid.argument;Constraint.p;Invalid operator $operator]
    }

    $self.operator[$self.opString[^operator.trim[]]]
    $self.version[$version]
###


#------------------------------------------------------------------------------
#:param provider type ConstraintInterface
#
#:result boolean
#------------------------------------------------------------------------------
@matches[provider][result]
    ^if($provider is Constraint){
        $result[^self.matchSpecific[$provider]]
    }{
        $result[^provider.matches[$self]]
    }]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@GET[][result]
    $result[$self.opInt.${self.operator} $self.version]
###


#------------------------------------------------------------------------------
#:param prettyString type string
#------------------------------------------------------------------------------
@SET_prettyString[prettyString]
    $self.prettyString[$prettyString]
###


#------------------------------------------------------------------------------
#:result string
#------------------------------------------------------------------------------
@GET_prettyString[]
    $result[$self.prettyString]
    ^if(!def $result){
        $result[^self.GET[]]
    }
###


#------------------------------------------------------------------------------
#:param provider type Constraint
#:param compareBranches type boolean
#
#:result boolean
#------------------------------------------------------------------------------
@matchSpecific[provider;compareBranches]
    $noEqualOp[^self.opInt.${self.operator}.replace['=';'']]
    $providerNoEqualOp[^self.opInt.${provider.operator}.replace['=';'']]

    $isEqualOp($self.OP_EQ == $self.operator)
    $isNonEqualOp($self.OP_NE == $self.operator)
    $isProviderEqualOp($self.OP_EQ == $provider.operator)
    $isProviderNonEqualOp($self.OP_NE == $provider.operator)

    ^if($isNonEqualOp || $isProviderNonEqualOp){
        ^rem['!=' operator is match when other operator is not '==' operator or version is not match]

        $result(
            !$isEqualOp && !$isProviderEqualOp
            || $self.versionCompare[$provider.version;$self.version;'!=';$compareBranches]
        )
    }($self.operator != $self.OP_EQ && $noEqualOp == $providerNoEqualOp){
        ^rem[the condition is <= 2.0 & < 1.0 always have a solution]

        $result(true)
    }($self.versionCompare[$provider.version;$self.version;$self.opInt.${this.operator};$compareBranches]){
        $result(true)

        ^if(
            $provider.version == $self.version
            && $self.opInt[$provider.operator] == $providerNoEqualOp
            && $self.opInt[$self.operator] != $noEqualOp
        ){
            ^rem[require >= 1.0 and provide < 1.0]
            ^rem[1.0 >= 1.0 but 1.0 is outside of the provided interval]

            $result[false]
        }
    }{
        $result(false)
    }
###


#------------------------------------------------------------------------------
#:param a type string
#:param b type string
#:param operator type string
#:param compareBrances type boolean
#
#:result boolean
#------------------------------------------------------------------------------
@versionCompare[a;b;operator;compareBrances][result]
    ^if(!^self.opString.contains[$operator]){
        ^throw[invalid.argument;Constraint.p;Invalid operator $operator]
    }

    $aIsBranch('dev-' eq ^a.mid(0;4))
    $bIsBranch('dev-' eq ^b.mid(0;4))

    if ($aIsBranch && $bIsBranch) {
        $result($operator == '==' && $a == $b)
    }(!$compareBranches && ($aIsBranch || $bIsBranch)) {
        ^rem[when branches are not comparable, we make sure dev branches never match anything]
        $result(false)
    }{
        $result(^self.phplikeVersionCompare[$a;$b;$operator])
    }
###


#------------------------------------------------------------------------------
#:param a type string
#:param b type string
#:param operator type string
#
#:result boolean
#------------------------------------------------------------------------------
@phplikeVersionCompare[a;b;operator][result]
    $result[]
    $tableA[^self.pointize[$a]]
    $tableB[^self.pointize[$b]]
    $indexA[^tableA.count[]]
    $indexB[^tableB.count[]]
    $index(^if($indexA > $indexB){$indexA}{$indexB})

    ^for[i](0;$index){

        ^rem[ TODO check all operators and $tableA.piece and $tableB.piece]

        $tableA.offset(1)
        $tableB.offset(1)
    }
###

#------------------------------------------------------------------------------
#:param version type string
#
#:result table
#------------------------------------------------------------------------------
@pointize[version][result]
    $version[^version.match[([\+\-\_])][g]{.}]
    $version[^version.match[([^^\.\d])][g]{.$match[1].}]
    $t[^version.split[.]]
###
