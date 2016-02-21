# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 12.03.2016
# Time: 23:26
# To change this template use File | Settings | File Templates.

@CLASS
CommandArgument

@OPTIONS
locals

@create[name;required]
    $self.name[$name]
    $self.required[$required]
###


@getName[]
    $result[$self.name]
###

@setName[name]
    $self.name[$name]
###

@isRequired[]
    $result[^self.required.bool[]]
###

@setRequired[isRequired]
    $self.required[^isRequired.bool[]]
###
