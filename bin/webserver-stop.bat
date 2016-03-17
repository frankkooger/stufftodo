:: stop het webserver.exe proces. stop eerst php-cgi
tskill php-cgi
tskill webserver
:: wacht 1 seconden tot de webserver heeft kunnen stoppen
sleep 1
