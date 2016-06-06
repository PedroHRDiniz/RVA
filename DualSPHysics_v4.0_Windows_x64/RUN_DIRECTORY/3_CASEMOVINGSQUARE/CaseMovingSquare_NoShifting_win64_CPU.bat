@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseMovingSquare
set dirout=%name%_NoShifting_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4CPU_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"
set measuretool="../../EXECS/MeasureTool4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -cpu -shifting:none -tmax:0.02
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluid -onlytype:-all,fluid -vars:+idp,+vel,+rhop,+press,+vor
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartSquare -onlytype:-all,moving 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Tank.vtk -onlymk:11
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Square -onlymk:21
if not "%ERRORLEVEL%" == "0" goto fail


:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

