# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.09.16
# Time: 1:35
# To change this template use File | Settings | File Templates.

@CLASS
TestCase

@OPTIONS
locals

@USE
Parsekit/DI/DI.p

@auto[]
###


@create[]
#   TODO remove di and create objects manually. Should implement autoloading firstly.
    $self.di[^DI::create[]]
    $self.successAsserts(0)
    $self.failedAsserts[^hash::create[]]
###


@_assert[value;message]
    ^if(!$value){
        ^throw[AssertFailedException;;$message]
    }{
        ^self.successAsserts.inc[]
    }
###


@assertString[value;expected;message]
    ^self._assert($value ne $expected)[$message]
###


@assertTrue[value;message]
    ^self._assert($value)[$message]
###


@assertFalse[value;message]
    ^self._assert(!$value)[$message]
###