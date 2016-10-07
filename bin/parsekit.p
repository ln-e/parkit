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
    $result[]
    $app[^Application::create[]]
    ^app.initialize[]
    ^app.run[]
#--- end of main
