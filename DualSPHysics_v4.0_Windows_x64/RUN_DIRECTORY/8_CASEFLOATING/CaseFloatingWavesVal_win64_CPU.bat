@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseFloatingWavesVal
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4CPU_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set measuretool="../../EXECS/MeasureTool4_win64.exe"
set computeforces="../../EXECS/ComputeForces4_win64.exe"
set floatinginfo="../../EXECS/FloatingInfo4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem a copy of CaseFloatingWavesVal_Flap.dat must exist in dirout

copy CaseFloatingWavesVal_Flap.dat %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -cpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartMoving -onlytype:-all,+moving -vars:+idp,+vel,+rhop,+press
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFloating -onlytype:-all,+floating 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFluid -onlytype:-all,+fluid -vars:+idp,+vel,+rhop,+press
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseFloatingWavesVal_heights.txt -onlytype:-all,+fluid -height:0.4 -savecsv %dirout%/%name%_heights
if not "%ERRORLEVEL%" == "0" goto fail

%computeforces% -dirin %dirout% -filexml %dirout%/%name%.xml -onlymk:61 -savecsv %dirout%/FloatingForce 
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
