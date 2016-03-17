@ECHO OFF

rem start het nginx webserver proces en het php-cgi proces

SET PHP_FCGI_MAX_REQUESTS=1000
SET PATH=C:\openadmin\PHP5;%PATH%

rem check eerst het php-cgi proces

tasklist /fi "Imagename eq php-cgi.exe" 2> nul | findstr "Console" > nul 

goto found%ERRORLEVEL%

:found0
::  echo Het php-cgi proces loopt
@ECHO ON
rem     PHP-CGI is already running!
@ECHO OFF
sleep 1
goto NEXT

:found1
::  echo Het php-cgi proces loopt NIET
hidec C:\openadmin\PHP5\php-cgi.exe -b localhost:8850

:NEXT

rem check nginx

tasklist /fi "Imagename eq nginx.exe" 2> nul | findstr "Console" > nul 

goto found%ERRORLEVEL%

:found0
::  echo Het nginx webserver proces loopt
@ECHO ON
rem     nginx is already running!
@ECHO OFF
sleep 1
goto END

:found1
::  echo Het webserver proces loopt NIET
START /D C:\openadmin\nginx /B nginx.exe
rem START /D C:\openadmin\nginx /B C:\openadmin\nginx\nginx.exe

:END

