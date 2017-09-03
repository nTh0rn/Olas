@echo off
@setlocal enableextensions enabledelayedexpansion
cd %~dp0
set dir=
cls
goto notfirsttime
::WIP code
if not exist "firstsetup.txt" (
goto notfirsttime
) else (
echo FIRST TIME SETUP
echo Would you like to install/update Olas into your command line?
echo.
echo (Doing so would allow you to open up Command Prompt and type commands like 'olas script.ola')
echo.
echo This prompt will open show up only on first setup. To see it again later, add 'firstsetup.txt' to this directory.
echo.
echo NOTE: COMMAND LINE SETUP ADMINISTRATOR PRIVILIAGES. PLEASE ASSURE YOU ARE IN ADMINISTRATOR MODE.
:firsttimeprompt
echo.
set /p ui=(Y/N):

if "%ui%"=="Y" (
copy "%~dp0/olas.bat" "C:\WINDOWS\system32"
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
cd %~dp0
if [%1] == [] goto term
set script=%1
goto parameterfound
:term
echo Compiler was started without console parameter.
echo.
echo Please type in the directory to the script you'd like to open.
echo.
echo Commands:
echo filename.ola (Select script to run)
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
::if not "%scriptdir:cd =%"=="%scriptdir%" (
::if exist "%scriptdir:cd =%" (
::cd %scriptdir:cd =%
::goto findscript
::)
::}
if not "%scriptdir:cd =%"=="%scriptdir%" (
if exist %scriptdir:cd =% (
%scriptdir%
) else (
echo Directory %scriptdir:cd =% does not exist.
goto findscript
)
goto findscript
)
if exist %scriptdir% (
set script=%scriptdir%
goto parameterfound
) else (
echo %scriptdir% does not exist.
goto findscript
)
goto findscript
:parameterfound
::cd %~dp0
if not exist "%script%" (
echo %script% Does not exist.
pause>nul
exit
)
set func_scan=true
:done_scanning
set /a currentlinecount=0
set prevvar=NULL
set var_outer=%
set errorcode=000
set ifparam1=0
set ifparam2=0
set ifparam1var=false
set ifparam2var=false
set ifcondi=0
set overrideline=NULL
set scriptdir=%cd%
set iftrue=true
setlocal EnableDelayedExpansion
set "cmd=findstr /R /N "^^" %script% | find /C ":""
for /f %%a in ('!cmd!') do set linecount=%%a

set /a linecount=%linecount%-1
cls
:run1
if not %currentlinecount%==%linecount% goto run2
if "%func_scan%"=="false" (
echo.
echo.
echo Program Done
pause>nul
exit
) else (
set func_scan=false
goto done_scanning
)
:run2
set /a currentlinecount=%currentlinecount%+1
set cline=
for /F "skip=%currentlinecount% delims=" %%i in (%scriptdir%\%script%) do if not defined cline set "cline=%%i"
if "%cline%"=="%prevline%" (
set errorcode=001
goto syntax_error
)
if "%cline%"==" " (
goto run1
)

set line=%cline%

if "%func_scan%"=="true" (
if not "%line:-func =%"=="%line%" goto func
goto run1
:func
set prevline=%line%
set line=%line:-func =%
set %line%=%currentlinecount%
goto run1
)

:ifcont
if not "%line:ifval1 =%"=="%line%" goto ifval1
if not "%line:ifcond =%"=="%line%" goto ifcond
if not "%line:ifval2 =%"=="%line%" goto ifval2
if not "%line:ifdo =%"=="%line%" goto ifdo
if not "%line:ifelsedo =%"=="%line%" goto ifelsedo
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
if not "%line:clean=%"=="%line%" goto clean
if not "%line:-func =%"=="%line%" goto func_after
if not "%line:end=%"=="%line%" goto end
if not "%line:showdir=%"=="%line%" goto showdir
if not "%line:cd =%"=="%line%" goto cd
set errorcode=002
goto syntax_error

:syntax
echo Syntax error line %currentlinecount%.
goto run1
:print
set prevline=%line%
set line=%line:print =%
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
set prevline=%line%
if not "%line:newline=%"=="" set errorcode=00004 & goto syntax_error
echo.
goto run2
:execute
set prevline=%line%
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
set prevline=%line%
set line=%line:input =%
set line=%line: =%
set /p x%line%=
goto run1



:decvar
set prevline=%line%
set line=%line:decvar =%
set line=%line: =%
set prevvar=x%line%
goto run1


:setvar
set prevline=%line%
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
set prevline=%line%
set line=%line:mathstart =%
set line=%line: =%
set mathvar=x%line%
set /a %mathvar%=0
goto run1

:mathadd
set prevline=%line%
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
set prevline=%line%
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
set prevline=%line%
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
set prevline=%line%
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
set prevline=%line%
::set mathvar=NULL
goto run1

:goto
set prevline=%line%
set line=%line:goto =%
set /a currentlinecount=%line%-1
goto run1

:ifval1
set prevline=%line%
set line=%line:ifval1 =%
if not "%line:`=%"=="%line%" goto ifval1_var
set ifparam1=%line%
goto run1

:ifval1_var
set line=%line:`=%
if defined x%line% (
set ifparam1=!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)

:ifcond
set prevline=%line%
set line=%line:ifcond =%
set line=%line: =%
set ifcondi=%line%
goto run1

:ifval2
set prevline=%line%
set line=%line:ifval2 =%
if not "%line:`=%"=="%line%" goto ifval2_var
set ifparam2=%line%
goto run1

:ifval2_var
set line=%line:`=%
if defined x%line% (
set ifparam2=!x%line%!
goto run1
) else (
set errorcode=005
goto syntax_error
)


:ifdo
set prevline=%line%
set line=%line:ifdo =%
if "%ifcondi%"=="gt" (
if %ifparam1% GTR %ifparam2% (
set iftrue=true
goto ifcont
goto run1
) else (
set iftrue=false
goto run1
)
)
if "%ifcondi%"=="lt" (
if "%ifparam1%" LSS "%ifparam2%" (
set iftrue=true
goto ifcont
goto run1
) else (
set iftrue=false
goto run1
)
)
if "%ifcondi%"=="eq" (
if "%ifparam1%"=="%ifparam2%" (
set iftrue=true
goto ifcont
goto run1
) else (
set iftrue=false
goto run1
)
)


set errorcode=006
goto syntax_error

:ifelsedo
set prevline=%line%
if "%iftrue%"=="false" (
set line=%line:ifelsedo =%
goto ifcont
) else (
goto run1
)


:clean
set prevline=%line%
cls
goto run1

:func_after
set prevline=%line%
goto run1

:end
exit


:showdir
set prevline=%line%
dir /b
goto run1

goto run1

:cd
set prevline=%line%
set line=%line:cd =%
if not "%line:`=%"=="%line%" goto cd_var
cd %line%
set scriptdir=%cd%
goto run1

:cd_var
set line=%line:`=%
if defined x%line% (
cd !x%line%!
set scriptdir=%cd%
goto run1
) else (
set errorcode=005
goto syntax_error
)


:syntax_error
echo.
echo.
echo Error %errorcode% - Line %currentlinecount%
echo.
for /F "skip=%errorcode% delims=" %%i in (error-codes.txt) do if not defined error set "error=%%i"
echo %error%
pause>nul
exit


:end
echo.
echo Program Done
pause>nul
