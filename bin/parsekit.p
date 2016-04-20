#!parser/parser3.cgi
@USE
Debug.p
Application.p


#------------------------------------------------------------------------------
#Main Do application initialization
#------------------------------------------------------------------------------
@main[][result]
    $app[^Application::create[]]

    $result[$result^info[]]
    $result[$result^taint[^#0A]]
    $result[$result^app.run[]]
    $result[$result^taint[^#0A]]
#--- end of main


#------------------------------------------------------------------------------
#Main::info - Prints information for each call
#------------------------------------------------------------------------------
@info[][result]
    $result[Parsekit 0.0.1 by Igor Bodnar. Tool for managing project dependency in parser3.]
#---
