@ECHO OFF
where parser3.exe >nul 2>nul
if %errorlevel%==1 (
    ".\cgi\parser3.exe" "%~dp0parsekit.p" %*
) else (
    "parser3.exe" "%~dp0parsekit.p" %*
)
