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
#:constructor
#
#:param requirements type hash
#------------------------------------------------------------------------------
@create[requirements]
    $self.conflicts[^hash::create[]]
    $self.baseRequirements[^hash::create[$requirements]]
    $self.allRequirements[^hash::create[$requirements]]
    $self.transitiveMap[^hash::create[]]
    $self.pickedPackages[^hash::create[]]
###


#------------------------------------------------------------------------------
#:param transitiveName type string
#:param baseName type string
#------------------------------------------------------------------------------
@addToTransitiveMap[transitiveName;baseName]
    ^if(!^self.transitiveMap.contains[$transitiveName]){
        $self.transitiveMap.$transitiveName[^hash::create[]]
    }
    $index[^self.transitiveMap.$transitiveName._count[]]
    $self.transitiveMap.[$transitiveName].[$index][$baseName]
    ^if(^self.transitiveMap.contains[$baseName]){
        ^self.transitiveMap.[$transitiveName].add[$self.transitiveMap.contains[$baseName]]
    }
###


#------------------------------------------------------------------------------
#:param packageName type string
#:param count type int
#------------------------------------------------------------------------------
@addConflict[packageName;count][result]
    ^if(!def $count){$count(1)}
    $self.conflicts.[$packageName]($self.conflicts.$packageName+$count)
###


#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
@extendConflictsByTransitiveMap[][result]
    $newConflicts[^hash::create[]]
    ^self.conflicts.foreach[conflictPackageName;conflictsCount]{
        ^if(^self.transitiveMap.contains[$conflictPackageName]){
            ^self.transitiveMap.[$conflictPackageName].foreach[i;packageName]{
                $newConflicts.[$packageName]($newConflicts.$packageName + 1)
            }
        }
    }

    ^newConflicts.foreach[name;count]{
        ^self.addConflict[$name;$count]
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
