
set /a currentlinecount=0
set prevline=
set var_outer=%
@echo off
@setlocal enableextensions enabledelayedexpansion
setlocal EnableDelayedExpansion
set "cmd=findstr /R /N "^^" input.ceq | find /C ":""
for /f %%a in ('!cmd!') do set linecount=%%a

set /a linecount=%linecount%-1
cls
:run1
if not %currentlinecount%==%linecount% goto run2
echo.
echo.
echo Program Done
pause>nul
exit
:run2
set /a currentlinecount=%currentlinecount%+1
set "cline="
for /F "skip=%currentlinecount% delims=" %%i in (input.ceq) do if not defined cline set "cline=%%i"
if "%setvar%"=="1" (
if not "%cline:x!line!=%"=="%cline%" (
set line=
set x%line%=
)
)
if "%cline%"=="%prevline%" (
echo.
echo.
echo Error 001
goto syntax_exit
)
set line=%cline%

if not "%line:print=%"=="%line%" goto print
if not "%line:execute=%"=="%line%" goto execute
if not "%line:input=%"=="%line%" goto input
if not "%line:newline=%"=="%line%" goto newline
echo.
echo.
echo Error 002 - Line %currentlinecount%
goto syntax_exit

:syntax
echo Syntax error line %currentlinecount%.
goto run1
:print
set prevline=%cline%
set line=%line:print=%
if not "%line:`=%"=="%line%" goto print_var
echo|set /p=%line%
goto run1
:print_var
set line=%line:`=%
set line=%line: =%
echo|set /p=!x%line%!
goto run1

:newline
set prevline=%cline%
if not "%line:newline=%"=="" goto newlineerror
echo.
goto run2

:newlineerror
echo.
echo.
echo Error 004 - Line %currentlinecount%
goto syntax_exit
:execute
set prevline=%cline%
set line=%line:execute =%
set line=%line:`=%
echo !x%line%!
set line=!x%line%!
if exist "%line%" (
if not "%line:`=%"=="%line%" goto execute_var
start %line%
) else (
echo.
echo.
echo Error 003 - Line %currentlinecount%
goto syntax_exit
)
goto run1
:execute_var
set line=%line:`=%
set line=%line: =%
start !x%line%!
goto run1

:input
set prevline=%cline%
set line=%line:input =%
set line=%line: =%
set /p x%line%=
goto run1


:var
set line=%line:var=%
set line=%line: =%
set setvar=1
goto run1


:syntax_exit
echo.
echo Encountered issue on line %currentlinecount%.
echo Lookup error code above in 'error-codes.txt'.
echo Or look at README.md for documentation.
pause>nul
exit

:end
echo.
echo Program Done
pause>nul
