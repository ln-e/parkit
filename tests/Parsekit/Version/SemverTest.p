# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.09.16
# Time: 1:33
# To change this template use File | Settings | File Templates.

@CLASS
SemverTest

@BASE
TestCase

@OPTIONS
locals

@auto[]
###


@create[]
    ^BASE:create[]
    $self.semver[$DI:semver]
###


@testSatisfies[]
#   Tilde range
#   ~1.2.3
    ^self.assertTrue[^self.semver.satisfies[1.2.3;~1.2.3]; ~1.2.3 should be >=1.2.3 <1.3.0, failed on 1.2.3]
    ^self.assertTrue[^self.semver.satisfies[1.2.99;~1.2.3]; ~1.2.3 should be >=1.2.3 <1.3.0, failed on 1.2.99]
    ^self.assertFalse[^self.semver.satisfies[1.2.0;~1.2.3]; ~1.2.3 should be >=1.2.3 <1.3.0, failed on 1.2.0]
    ^self.assertFalse[^self.semver.satisfies[1.3.0;~1.2.3]; ~1.2.3 should be >=1.2.3 <1.3.0, failed on 1.3.0]

#   ~1.2
    ^self.assertTrue[^self.semver.satisfies[1.2.0;~1.2]; ~1.2 should be >=1.2.0 <2.0.0, failed on 1.2.0]
    ^self.assertTrue[^self.semver.satisfies[1.99.99;~1.2]; ~1.2 should be >=1.2.0 <2.0.0, failed on 1.99.99]
    ^self.assertTrue[^self.semver.satisfies[1.3.0;~1.2]; ~1.2 should be >=1.2.0 <2.0.0, failed on 1.3.0]
    ^self.assertFalse[^self.semver.satisfies[2.0.0;~1.2]; ~1.2 should be >=1.2.0 <2.0.0, failed on 2.0.0]

#   ~1
    ^self.assertTrue[^self.semver.satisfies[1.0.0;~1]; ~1 should be >=1.0.0 <2.0.0, failed on 1.2.0]
    ^self.assertTrue[^self.semver.satisfies[1.0.99;~1]; ~1 should be >=1.0.0 <2.0.0, failed on 1.0.99]
    ^self.assertTrue[^self.semver.satisfies[1.99.99;~1]; ~1 should be >=1.0.0 <2.0.0, failed on 1.99.99]
    ^self.assertFalse[^self.semver.satisfies[2.0.0;~1]; ~1 should be >=1.0.0 <2.0.0, failed on 2.0.0]



    $result[$self.successAsserts]
###