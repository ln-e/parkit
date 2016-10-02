#!cgi/parser3.cgi


#-----------------------------------------------------------------------------
#auto
#-----------------------------------------------------------------------------
@auto[][locals]
$temp[^table::create{path
../classes
../src
../src/Parsekit
../src/Parsekit/Command
../src/Parsekit/DI
../src/Parsekit/Exec
../src/Parsekit/Installer
../src/Parsekit/Installer/Driver
../src/Parsekit/Package
../src/Parsekit/Repository
../src/Parsekit/Resolver
../src/Parsekit/Utils
../src/Parsekit/Version
../src/Parsekit/Version/Constraint
../tests
}]
    ^MAIN:CLASS_PATH.join[$temp]
    ^if($is_developer is junction && ^is_developer[]){
        ^use[Debug.p]
    }
###


#-----------------------------------------------------------------------------
#autouse
#
#:param className type string
#-----------------------------------------------------------------------------
@autouse[className]
    ^use[${className}.p]
###


#------------------------------------------------------------------------------
#Main Do application initialization
#------------------------------------------------------------------------------
@main[][result]
    $app[^Application::create[]]

    $result[$result^info[]]
    $result[$result^app.run[]]
    $result[$result^#0A]
#--- end of main


#------------------------------------------------------------------------------
#Main::info - Prints information for each call
#------------------------------------------------------------------------------
@info[][result]
    $result[Parsekit 0.0.1 by Igor Bodnar. Tool for managing project dependencies in parser3.]
#---
