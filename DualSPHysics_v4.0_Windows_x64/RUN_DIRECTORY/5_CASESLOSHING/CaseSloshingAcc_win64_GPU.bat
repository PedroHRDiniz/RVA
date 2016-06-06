@echo off

rem "name" and "dirout" are named according to the testcase

set name=CaseSloshingAcc
set dirout=%name%_out

rem "executables" are renamed and called from their directory

set gencase="../../EXECS/GenCase4_win64.exe"
set dualsphysics="../../EXECS/DualSPHysics4_win64.exe"
set boundaryvtk="../../EXECS/BoundaryVTK4_win64.exe"
set partvtk="../../EXECS/PartVTK4_win64.exe"
set partvtkout="../../EXECS/PartVTKOut4_win64.exe"
set measuretool="../../EXECS/MeasureTool4_win64.exe"

rem "dirout" is created to store results or it is removed if it already exists

if exist %dirout% del /Q %dirout%\*.*
if not exist %dirout% mkdir %dirout%

rem a copy of CaseSloshingAccData.csv must exist in dirout

copy CaseSloshingAccData.csv %dirout%

rem CODES are executed according the selected parameters of execution in this testcase

%gencase% %name%_Def %dirout%/%name% -save:all
if not "%ERRORLEVEL%" == "0" goto fail

%dualsphysics% %dirout%/%name% %dirout% -svres -gpu 
if not "%ERRORLEVEL%" == "0" goto fail

%partvtk% -dirin %dirout% -savevtk %dirout%/PartAll -onlytype:+all
if not "%ERRORLEVEL%" == "0" goto fail

%partvtkout% -dirin %dirout% -filexml %dirout%/%name%.xml -savevtk %dirout%/PartFluidOut -SaveResume %dirout%/ResumeFluidOut
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseSloshingAcc_PointsPressure_Incorrect.txt -onlytype:-all,+fluid -vars:-all,+press,+kcorr -kcusedummy:0 -kclimit:0.5 -savevtk %dirout%/PointsPressure_Incorrect -savecsv %dirout%/PointsPressure_Incorrect
if not "%ERRORLEVEL%" == "0" goto fail

%measuretool% -dirin %dirout% -points CaseSloshingAcc_PointsPressure_Correct.txt -onlytype:-all,+fluid -vars:-all,+press,+kcorr -kcusedummy:0 -kclimit:0.5 -savevtk %dirout%/PointsPressure_Correct -savecsv %dirout%/PointsPressure_Correct
if not "%ERRORLEVEL%" == "0" goto fail


:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause
