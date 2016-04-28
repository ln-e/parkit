# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 12.03.2016
# Time: 23:26
# To change this template use File | Settings | File Templates.

@CLASS
CommandArgument

@OPTIONS
locals


#------------------------------------------------------------------------------
#:constructor
#
#:param name type string
#:param required type boolean
#:param defaultValue
#------------------------------------------------------------------------------
@create[name;required;defaultValue]
    $self.name[$name]
    $self.required[$required]
    $self.defaultValue[$defaultValue]
###


#------------------------------------------------------------------------------
#Get name of the argument
#
#:result string
#------------------------------------------------------------------------------
@getName[]
    $result[$self.name]
###


#------------------------------------------------------------------------------
#Set name of the argument
#
#:param name type string
#------------------------------------------------------------------------------
@setName[name]
    $self.name[$name]
###


#------------------------------------------------------------------------------
#Check whatever argument is required
#
#:result boolean
#------------------------------------------------------------------------------
@isRequired[]
    $result[^self.required.bool[]]
###


#------------------------------------------------------------------------------
#Set flag that argument is required
#
#:param isRequired type boolean
#------------------------------------------------------------------------------
@setRequired[isRequired]
    $self.required[^isRequired.bool[]]
###
