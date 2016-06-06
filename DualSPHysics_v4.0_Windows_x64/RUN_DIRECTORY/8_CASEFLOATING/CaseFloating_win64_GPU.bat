@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseFloating
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set isosurface="../../EXECS/IsoSurface4_win64.exe"
set floatinginfo="../../EXECS/FloatingInfo4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -gpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFluid -onlytype:-all,+fluid 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFloating -onlytype:-all,+floating
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartPiston -onlytype:-all,+moving
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/Box.vtk -onlymk:31
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/MotionFloating -onlymk:61
if not "%ERRORLEVEL%" == "0" goto fail

%boundaryvtk% -loadvtk %dirout%/%name%__Dp.vtk -filexml %dirout%/%name%.xml -motiondata %dirout% -savevtkdata %dirout%/MotionPiston -onlymk:21
if not "%ERRORLEVEL%" == "0" goto fail

%isosurface% -dirin %dirout% -saveiso %dirout%/Surface 
if not "%ERRORLEVEL%" == "0" goto fail

%floatinginfo% -filexml %dirout%/%name%.xml -onlymk:61 -savemotion -savedata %dirout%/FloatingMotion 
if not "%ERRORLEVEL%" == "0" goto fail


:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

