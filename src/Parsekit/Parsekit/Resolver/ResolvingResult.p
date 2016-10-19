# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 27.04.16
# Time: 23:36
# To change this template use File | Settings | File Templates.

@CLASS
ResolvingResult

@OPTIONS
locals

@auto[]
###


#------------------------------------------------------------------------------
#:param packages type hash
#:param iteration type number
#------------------------------------------------------------------------------
@create[packages;iteration]
    $self.packages[$packages]
    $self.iteration($iteration)
###

