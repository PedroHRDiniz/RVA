@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseWavemaker2D
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK_4win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set measuretool="../../EXECS/MeasureTool4_win64.exe"
set isosurface="../../EXECS/IsoSurface4_win64.exe"
set computeforces="../../EXECS/ComputeForces4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem a copy of CaseWavemaker2D_Piston_Movement.dat must exist in dirout

copy CaseWavemaker2D_Piston_Movement.dat %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -gpu
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartFluid -onlytype:-all,+fluid
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartMoving -onlytype:-all,+moving
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseWavemaker2D_wg1_2D.txt -onlytype:-all,+fluid -height -savecsv %dirout%/wg1 -savevtk %dirout%/wg1
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseWavemaker2D_wg2_2D.txt -onlytype:-all,+fluid -height -savecsv %dirout%/wg2 -savevtk %dirout%/wg2
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseWavemaker2D_wg3_2D.txt -onlytype:-all,+fluid -height -savecsv %dirout%/wg3 -savevtk %dirout%/wg3
if not "%ERRORLEVEL%" == "0" goto fail
 
%computeforces% -dirin %dirout% -filexml %dirout%/%name%.xml -onlyid:1616-1669 -savecsv %dirout%/WallForce 
if not "%ERRORLEVEL%" == "0" goto fail
rem Note that initial hydrostatic force is 20.72 N (initial column water 0.065 high) 



:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause
