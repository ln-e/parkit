@ECHO OFF
set CGI_PARSER_CONFIG=%~dp0../parser/auto.p
where parser3.exe >nul 2>nul
if %errorlevel%==1 (
    "./parser/parser3.exe" "%~dp0parsekit.p" %*
) else (
    "parser3.exe" "%~dp0parsekit.p" %*
)
