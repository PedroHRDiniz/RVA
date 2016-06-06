@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseTwoPhases
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysicsMultiphase_3.4_win64"
set partvtk="../../EXECS/PartVTK4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem CODES are executed according the selected parameters of execution in this tescase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -gpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluid -onlymk:1 -savevtk %dirout%/PartSediment -onlymk:2
if not "%ERRORLEVEL%" == "0" goto fail



:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

