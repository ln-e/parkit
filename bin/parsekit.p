#!parser/parser3.cgi
@USE
Debug.p
Application.p

@main[]
    $app[^Application::create[]]

    $result[^info[]
    ^app.run[]
]
###

@info[]
    $result[Parsekit 0.0.1 by Igor Bodnar. Tool for managing project dependency in parser3.]
###



