@echo off
rem
rem Start openadmin met nginx als webserver
rem
rem errorlevel is 1 indien niet gevonden
rem errorlevel is 0 indien gevonden
rem
rem
rem Tasklist  is a part of Windows XP Professional and above, it does not come
rem with the XP Home edition. Therefore a tasklist.exe is disbributed in this directory
rem

tasklist /fi "Imagename eq nginx.exe" 2> nul | findstr "Console" > nul 

goto :found%ERRORLEVEL%

:found0
rem  echo Het webserver proces loopt
rem  tskill webserver
rem  goto :EOF
goto :PAGE

:found1
rem  echo Het webserver proces loopt NIET
hidec nginx-start.bat

:PAGE

START /B http://localhost/

