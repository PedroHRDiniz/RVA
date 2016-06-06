@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseSolids
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4CPU_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set isosurface="../../EXECS/IsoSurface4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -cpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFluid -onlytype:-all,+fluid 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartBlocks -onlytype:-all,+floating 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Actual.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Box.vtk -onlymk:11
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Actual.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/MotionBlocks -onlymk:62-79
if not "%ERRORLEVEL%" == "0" goto fail

%isosurface% -dirin %dirout% -saveiso %dirout%/Surface 
if not "%ERRORLEVEL%" == "0" goto fail


:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

