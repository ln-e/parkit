# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 13.02.16
# Time: 14:12
# To change this template use File | Settings | File Templates.

@CLASS
RequireCommand

@USE
CommandInterface.p
CommandArgument.p
Parsekit/Repository/BaseRepository.p

@OPTIONS
locals

@BASE
CommandInterface

@create[]
###

@GET_description[]
    $result[add dependency to project]
###

@GET_argumentsConfig[]
    $result[
        ^hash::create[
            $.packageName[
                ^CommandArgument::create[packageName;true]
            ]
            $.packageVersion[
                ^CommandArgument::create[packageVersion;false]
            ]
        ]
    ]
###

@execute[arguments]
    $jsonFile[^JsonFile::create[/parsekit.json]]
    $data[^jsonFile.read[]]
    $data.require.[$arguments.packageName][v0.0.1-beta]

    ^jsonFile.write[$data]
    $repository[^BaseRepository::create[]]
    $result[founded: ^repository.findPackage[$arguments.packageName]]
###
