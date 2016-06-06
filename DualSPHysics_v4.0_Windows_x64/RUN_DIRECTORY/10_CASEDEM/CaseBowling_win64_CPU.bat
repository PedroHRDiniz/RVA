@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseBowling
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4CPU_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -cpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartSolids -onlytype:-all,+floating
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Tank.vtk -onlymk:11
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Ball -onlymk:20
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Bowls -onlymk:21-90
if not "%ERRORLEVEL%" == "0" goto fail



:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

