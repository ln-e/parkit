#!cgi/parser3.cgi


#-----------------------------------------------------------------------------
#auto
#-----------------------------------------------------------------------------
@auto[][locals]
    ^use[../vault/classpath.p]
    ^if($is_developer is junction && ^is_developer[]){
        ^use[Debug.p]
    }
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
