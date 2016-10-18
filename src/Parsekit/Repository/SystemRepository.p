# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 19.10.16
# Time: 0:52
# To change this template use File | Settings | File Templates.

@CLASS
SystemRepository

@OPTIONS
locals


@BASE
BaseRepository

@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
# Repository contains only OS "packages". Like parser itselt or any
# extensions/modules if needed
#------------------------------------------------------------------------------
@create[]
    ^BASE:create[]

    ^self.configurePackages[]
###


#------------------------------------------------------------------------------
# Register all supported packages
#------------------------------------------------------------------------------
@configurePackages[]
    $parserVersion[^env:PARSER_VERSION.mid(0;^env:PARSER_VERSION.pos[ ])]

    $self.packages.parser[
        $.parser[
            $.$parserVersion[
                $.name[parser]
                $.version[$parserVersion]
            ]
        ]
    ]
###


#------------------------------------------------------------------------------
#:param packageName type string
#
#:result bool
#------------------------------------------------------------------------------
@hasPackage[packageName][result]
    $result[^self.packages.contains[$packageName]]
###


#------------------------------------------------------------------------------
#:param packageName type string
#
#:result hash
#------------------------------------------------------------------------------
@loadPackages[packageName][result]
    $result[$self.packages.$packageName]
###
