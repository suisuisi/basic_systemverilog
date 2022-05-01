@echo off
rem ------------------------------------------------------------------------------
rem  clean_vivado.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this file as a boilerplate for your custom clean script
rem   for Vivado projects


SET PROJ=test

del /s /f /q .\%PROJ%.cache\*
rmdir /s /q  .\%PROJ%.cache\

del /s /f /q .\%PROJ%.hw\*
rmdir /s /q  .\%PROJ%.hw\

rem del /s /f /q .\%PROJ%.runs\*
rem rmdir /s /q  .\%PROJ%.runs\

del /s /f /q .\%PROJ%.sim\*
rmdir /s /q  .\%PROJ%.sim\

del /s /f /q .\.Xil\*
rmdir /s /q  .\.Xil\

del /s /f /q .\*.jou
del /s /f /q .\*.log

pause
goto :eof

