@echo off
@setlocal enableextensions enabledelayedexpansion
cd %~dp0
set dir=
cls
if not exist "firstsetup.txt" (
goto notfirsttime
) else (
echo FIRST TIME SETUP
echo Would you like to install/update Cequal into your command line?
echo.
echo (Doing so would allow you to open up Command Prompt and type commands like 'ceq script.ceq')
echo.
echo This prompt will open show up only on first setup. To see it again later, add 'firstsetup.txt' to this directory.
echo.
echo NOTE: COMMAND LINE SETUP ADMINISTRATOR PRIVILIAGES. PLEASE ASSURE YOU ARE IN ADMINISTRATOR MODE.
:firsttimeprompt
echo.
set /p ui=(Y/N):

if "%ui%"=="Y" (
copy "%~dp0/ceq.bat" "C:\WINDOWS\system32"
del firstsetup.txt
goto notfirsttime
)
if "%ui%"=="N" (
del firstsetup.txt
goto notfirsttime
)
echo Please only respond with either 'Y' or 'N'.
goto firsttimeprompt
)
:notfirsttime
if [%1] == [] goto term
set script=%1
goto parameterfound
:term
echo Compiler was started without console parameter.
echo.
echo Please type in the directory to the script you'd like to open.
echo.
echo Commands:
echo filename.ceq (Select script to run)
echo showdir (Show files in directory)
echo cd .. (Move up a directory)
echo cd pathname (Move into a directory)
echo.
:findscript
set /p scriptdir=%CD%^>

if "%scriptdir%"=="cd .." (
cd ..
goto findscript
)
if "%scriptdir%"=="showdir" (
dir /b
goto findscript
)
if exist "%scriptdir%" (
set script=%scriptdir%
goto parameterfound
) else (
echo %scriptdir% does not exist.
goto findscript
)
if exist "%scriptdir:cd =%" (
cd %scriptdir:cd =%
goto findscript
)

:parameterfound
set /a currentlinecount=0
set prevvar=NULL
set var_outer=%
set errorcode=000
setlocal EnableDelayedExpansion
set "cmd=findstr /R /N "^^" %script% | find /C ":""
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
for /F "skip=%currentlinecount% delims=" %%i in (%script%) do if not defined cline set "cline=%%i"
if "%setvar%"=="1" (
if not "%cline:x!line!=%"=="%cline%" (
set line=
set x%line%=
)
)
if "%cline%"=="%prevline%" (
set errorcode=001
goto syntax_error
)
set line=%cline%

if not "%line:print =%"=="%line%" goto print
if not "%line:execute =%"=="%line%" goto execute
if not "%line:input =%"=="%line%" goto input
if not "%line:newline=%"=="%line%" goto newline
if not "%line:decvar =%"=="%line%" goto decvar
if not "%line:setvar =%"=="%line%" goto setvar
if not "%line:mathstart =%"=="%line%" goto mathstart
if not "%line:mathadd =%"=="%line%" goto mathadd
if not "%line:mathsub =%"=="%line%" goto mathsub
if not "%line:mathmult =%"=="%line%" goto mathmult
if not "%line:mathdiv =%"=="%line%" goto mathdiv
if not "%line:goto =%"=="%line%" goto goto
if not "%line:mathend=%"=="%line%" goto mathend
set errorcode=002
goto syntax_error

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
if defined x%line% (
echo|set /p=!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:newline
set prevline=%cline%
if not "%line:newline=%"=="" set errorcode=004 & goto syntax_error
echo.
goto run2
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
set errorcode=003
goto syntax_error
)
goto run1
:execute_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
start !x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:input
set prevline=%cline%
set line=%line:input =%
set line=%line: =%
set /p x%line%=
goto run1



:decvar
set prevline=%cline%
set line=%line:decvar =%
set line=%line: =%
set prevvar=x%line%
goto run1


:setvar
set prevline=%cline%
set line=%line:setvar =%
if not "%line:`=%"=="%line%" goto setvar_var
set %prevvar%=%line%
set prevvar=NULL
goto run1
:setvar_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set %prevvar%=!x%line%!
set prevvar=NULL
goto run1
) else (
set errorcode=005
goto syntax_error
)

:mathstart
set prevline=%cline%
set line=%line:mathstart =%
set line=%line: =%
set mathvar=x%line%
set /a %mathvar%=0
goto run1

:mathadd
set prevline=%cline%
set line=%line:mathadd =%
if not "%line:`=%"=="%line%" goto mathadd_var
set /a %mathvar%=!%mathvar%!+%line%
goto run1
:mathadd_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!+!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:mathsub
set prevline=%cline%
set line=%line:mathsub =%
if not "%line:`=%"=="%line%" goto mathsub_var
set /a %mathvar%=!%mathvar%!-!x%line%!
goto run1
:mathsub_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!-!%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:mathmult
set prevline=%cline%
set line=%line:mathmult =%
if not "%line:`=%"=="%line%" goto mathmult_var
set /a %mathvar%=!%mathvar%!*%line%
goto run1
:mathmult_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!*!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)
:mathdiv
set prevline=%cline%
set line=%line:mathdiv =%
if not "%line:`=%"=="%line%" goto mathdiv_var
set /a %mathvar%=!%mathvar%!/%line%
goto run1
:mathdiv_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!/!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:mathend
set prevline=%cline%
::set mathvar=NULL
goto run1

:goto
set prevline=%cline%
set line=%line:goto =%
set /a currentlinecount=%line%-1
goto run1

:syntax_error
echo.
echo.
echo Error %errorcode% - Line %currentlinecount%
echo.
echo Lookup error code above in 'error-codes.txt'.
echo Or look at README.md for documentation.
pause>nul
exit


:end
echo.
echo Program Done
pause>nul
