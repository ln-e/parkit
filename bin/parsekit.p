#!parser/parser3.cgi
@USE
Debug.p
Erusage.p
Application.p


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
    $result[Parsekit 0.1.0 by Igor Bodnar. Tool for managing project dependencies in parser3.]
#---
