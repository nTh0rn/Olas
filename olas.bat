@echo off
@setlocal enableextensions enabledelayedexpansion
cd %~dp0
set dir=
set func_scan=true
cls
:term
echo Olas by Nick T.
echo https://github.com/NikTee/Olas
::echo Modification by YourNameHere
::Code above to give yourself credit if you distribute your own version of Olas.
echo Type the name of your script to run it. (Example: "script.ola")
echo.
:term2
echo.
set /p line=%CD%^>
if not "%line:.ola=%"=="%line%" goto ola_run
if not "%line:ifval1 =%"=="%line%" goto ifval1
if not "%line:ifcond =%"=="%line%" goto ifcond
if not "%line:ifval2 =%"=="%line%" goto ifval2
if not "%line:ifdo =%"=="%line%" goto ifdo
if not "%line:ifelsedo =%"=="%line%" goto not_term
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
if not "%line:goto =%"=="%line%" goto not_term
if not "%line:mathend=%"=="%line%" goto mathend
if not "%line:clean=%"=="%line%" goto clean
if not "%line:-func =%"=="%line%" goto not_term
if not "%line:end=%"=="%line%" goto end
if not "%line:showdir=%"=="%line%" goto showdir
if not "%line:cd =%"=="%line%" goto cd
if not "%line:help=%"=="%line%" goto help
set errorcode=002
goto syntax_error_term

:not_term
echo.
echo The function you used is not supported in the Olas terminal.
goto term2

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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:print_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
echo|set /p=!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:newline
set prevline=%line%
if not "%line:newline=%"=="" set errorcode=00004 & goto syntax_error
echo.
if not "%func_scan%"=="true" (
goto run2
) else (
goto term2
)
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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:execute_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
start !x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:input
set prevline=%line%
set line=%line:input =%
set line=%line: =%
set /p x%line%=
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)



:decvar
set prevline=%line%
set line=%line:decvar =%
set line=%line: =%
set prevvar=x%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)


:setvar
set prevline=%line%
set line=%line:setvar =%
if not "%line:`=%"=="%line%" goto setvar_var
set %prevvar%=%line%
set prevvar=NULL
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:setvar_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set %prevvar%=!x%line%!
set prevvar=NULL
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:mathadd
set prevline=%line%
set line=%line:mathadd =%
if not "%line:`=%"=="%line%" goto mathadd_var
set /a %mathvar%=!%mathvar%!+%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:mathadd_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!+!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:mathsub
set prevline=%line%
set line=%line:mathsub =%
if not "%line:`=%"=="%line%" goto mathsub_var
set /a %mathvar%=!%mathvar%!-!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:mathsub_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!-!%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:mathmult
set prevline=%line%
set line=%line:mathmult =%
if not "%line:`=%"=="%line%" goto mathmult_var
set /a %mathvar%=!%mathvar%!*%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:mathmult_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!*!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)
:mathdiv
set prevline=%line%
set line=%line:mathdiv =%
if not "%line:`=%"=="%line%" goto mathdiv_var
set /a %mathvar%=!%mathvar%!/%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
:mathdiv_var
set line=%line:`=%
set line=%line: =%
if defined x%line% (
set /a %mathvar%=!%mathvar%!/!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:ifval1
set prevline=%line%
set line=%line:ifval1 =%
if not "%line:`=%"=="%line%" goto ifval1_var
set ifparam1=%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:ifval1_var
set line=%line:`=%
if defined x%line% (
set ifparam1=!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:ifcond
set prevline=%line%
set line=%line:ifcond =%
set line=%line: =%
set ifcondi=%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:ifval2
set prevline=%line%
set line=%line:ifval2 =%
if not "%line:`=%"=="%line%" goto ifval2_var
set ifparam2=%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:ifval2_var
set line=%line:`=%
if defined x%line% (
set ifparam2=!x%line%!
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set iftrue=false
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
)
)
if "%ifcondi%"=="lt" (
if "%ifparam1%" LSS "%ifparam2%" (
set iftrue=true
goto ifcont
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set iftrue=false
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
)
)
if "%ifcondi%"=="eq" (
if "%ifparam1%"=="%ifparam2%" (
set iftrue=true
goto ifcont
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set iftrue=false
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
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
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
)


:clean
set prevline=%line%
cls
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:func_after
set prevline=%line%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:end
exit


:showdir
set prevline=%line%
dir /b
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:cd
set prevline=%line%
set line=%line:cd =%
if not "%line:`=%"=="%line%" goto cd_var
cd %line%
set scriptdir=%cd%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)

:cd_var
set line=%line:`=%
if defined x%line% (
cd !x%line%!
set scriptdir=%cd%
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)
) else (
set errorcode=005
goto syntax_error
)

:help
echo.
echo print .........."Prints given parameter." ------------------------[Variable or text parameter]
echo newline ........"Prints a new line." -----------------------------[No parameter]
echo execute ........"Executes given parameter" -----------------------[Variable or text parameter]
echo clean .........."Clears text in terminal." -----------------------[No parameter]
echo showdir ........"Shows contents of current directory." -----------[Variable or text parameter]
echo cd ............."Changes directory to parameter." ----------------[Variable or text parameter]
echo end ............"Exits script." ----------------------------------[Variable or text parameter]
echo decvar ........."Declares variable name." ------------------------[Text parameter]
echo setvar ........."Sets variable contents." ------------------------[Variable or text parameter]
echo input .........."Allows user to input variable's contents." ------[Variable or text parameter]
echo mathstart ......"Declares math variable name." -------------------[Text parameter]
echo mathadd ........"Adds to math variable." -------------------------[Text parameter]
echo mathsub ........"Subtracts from math variable." ------------------[Text parameter]
echo mathmult ......."Multiplies math variable." ----------------------[Text parameter]
echo mathdiv ........"Divides math variable." -------------------------[Text parameter]
echo mathend ........"Ends and saves math variable." ------------------[Text parameter]
echo -func .........."Declares function." -----------------------------[Text parameter]
echo goto ..........."Goes to function." ------------------------------[Text parameter]
echo ifval1 ........."Sets first if-statement value." -----------------[Variable or text parameter]
echo ifcond ........."Sets if-statement condition." -------------------[Limited text parameter]
echo ifval2 ........."Sets second if-statement value." ----------------[Variable or text parameter]
echo ifdo ..........."Sets what to do if if-statement is true." -------[Function parameter]
echo ifelsedo ......."Sets what to do if if-statement is false." ------[Function parameter]
if not "%func_scan%"=="true" (
goto run1
) else (
goto term2
)


:ola_run
if exist %line% (
set script=%line%
goto done_scanning
) else (
echo %line% does not exist.
set errorcode=003
if not "%func_scan%"=="true" (
goto syntax_error
) else (
goto term2
)
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

:syntax_error_term
echo.
echo.
echo Error %errorcode% - Line %currentlinecount%
echo.
for /F "skip=%errorcode% delims=" %%i in (error-codes.txt) do if not defined error set "error=%%i"
echo %error%
goto term2


:end
echo.
echo Program Done
pause>nul
