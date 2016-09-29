#!parser/parser3.cgi
@USE
Debug.p
TestCase.p


#------------------------------------------------------------------------------
#Do tests initialization
#------------------------------------------------------------------------------
@main[][result]
    $self.testClasses[^hash::create[]]
    ^self.findTests[../tests]
    ^self.executeTests[]
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
