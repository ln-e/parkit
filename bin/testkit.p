#!cgi/parser3.cgi

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
../tests/Parsekit
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
#Do tests initialization
#------------------------------------------------------------------------------
@main[][result]
    ^use[../tests/TestCase.p]
    $self.testClasses[^hash::create[]]
    ^self.findTests[../tests]
    $result[^self.executeTests[]^#0A]
#--- end of main


@executeTests[][result]
    ^self.testClasses.foreach[className;object]{
        $methods[^reflection:methods[$className]]
        ^methods.foreach[methodName;value]{
            ^if(^methodName.left(4) eq test){
                ^object.$methodName[]
            }
        }
    }
###

@findTests[dir][result;locals]
    $list[^file:list[$dir]]
    ^list.menu{
        ^if($list.dir){
            ^self.findTests[$dir/$list.name]
        }(^list.name.match[Test.p^$][in]>0){
            $className[^list.name.mid(0;^list.name.length[] - 2)]
            ^use[^dir.replace[tests;src]/^list.name.replace[Test.p;.p]]
            ^use[$dir/$list.name]
            $self.testClasses.$className[^reflection:create[$className;create]]
        }
    }
###


#------------------------------------------------------------------------------
#Main::info - Prints information for each call
#------------------------------------------------------------------------------
@info[][result]
    $result[Testkit 0.0.1 by Igor Bodnar. Tool for test parser3 projects.]
#---
