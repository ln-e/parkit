# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 25.04.16
# Time: 1:08
# To change this template use File | Settings | File Templates.

@CLASS
EmptyConstraint

@OPTIONS
locals

@USE
ConstraintInterface.p

@BASE
ConstraintInterface

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#------------------------------------------------------------------------------
@create[]
    $self.prettyString[]
###


#------------------------------------------------------------------------------
#:param provider type ConstraintInterface
#
#:result boolean
#------------------------------------------------------------------------------
@matches[provider]
    ^throw[Abstract method not implemented]
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
#:result string
#------------------------------------------------------------------------------
@GET[][result]
    $result[^[^]]
###