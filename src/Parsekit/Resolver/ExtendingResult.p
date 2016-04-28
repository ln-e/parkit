# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 27.04.16
# Time: 23:38
# To change this template use File | Settings | File Templates.

@CLASS
ExtendingResult

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:param requirements type hash
#------------------------------------------------------------------------------
@create[requirements]
    $self.conflicts[^hash::create[]]
    $self.baseRequirements[^hash::create[$requirements]]
    $self.allRequirements[^hash::create[$requirements]]
###


#------------------------------------------------------------------------------
#:param packageName type string
#------------------------------------------------------------------------------
@addConflict[packageName][result]
    $self.conflicts.[$packageName]($self.conflicts.$packageName+1)
###


#------------------------------------------------------------------------------
#:param packageName type string
#:param appendingConstraint type string
#------------------------------------------------------------------------------
@appendConstraint[packageName;appendingConstraint][result]
    $self.allRequirements.[$packageName][$self.allRequirements.[$packageName] $appendingConstraint]
###


#------------------------------------------------------------------------------
# Check whatever allRequirements contains new packages which wasn't in base
#
#:result bool
#------------------------------------------------------------------------------
@containsNewRequirements[][result]
    $result(def ^self.allRequirements.sub[$self.baseRequirements])
###