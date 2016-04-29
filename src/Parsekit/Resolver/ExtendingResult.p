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
    $self.transitiveMap[^hash::create[]]
###


@addToTransitiveMap[transitiveName;baseName]
    ^if(!^self.transitiveMap.contains[$transitiveName]){
        $self.transitiveMap.$transitiveName[^hash::create[]]
    }
    $index[^self.transitiveMap.$transitiveName._count[]]
    $self.transitiveMap.[$transitiveName].[$index][$baseName]
###


#------------------------------------------------------------------------------
#:param packageName type string
#------------------------------------------------------------------------------
@addConflict[packageName][result]
    $self.conflicts.[$packageName]($self.conflicts.$packageName+1)
###


#------------------------------------------------------------------------------
#:param packageName type string
#------------------------------------------------------------------------------
@addConflictByTransitiveMap[packageName;transitiveMap][result]
    ^self.addConflict[$packageName]
    ^if(def $transitiveMap && ^transitiveMap.contains[$packageName]){
        ^transitiveMap.$packageName.foreach[k;conflictName]{
            ^self.addConflict[$conflictName]
            ^self.addConflictByTransitiveMap[$conflictName;$transitiveMap]
        }
    }
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
@containsNewRequirements[][result;tmpHash]
    $tmpHash[^hash::create[$self.allRequirements]]
    ^tmpHash.sub[$self.baseRequirements]
    $result(def $tmpHash)
###
