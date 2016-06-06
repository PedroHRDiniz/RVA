@echo off
set gencase="../EXECS/GenCase4_win64.exe"
set boundaryvtk="../EXECS/BoundaryVTK4_win64.exe"


set name=Motion01

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion02

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion03

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion04

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion05

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion06

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion07

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion08

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail


set name=Motion09

if exist %name% del /Q %name%\*.*
if not exist %name% mkdir %name%

%gencase% %name% %name%/%name%
if not "%ERRORLEVEL%" == "0" goto fail
%boundaryvtk% -loadvtk %name%/%name%__Actual.vtk -filexml %name%/%name%.xml -savevtkdata %name%/%name%.vtk
if not "%ERRORLEVEL%" == "0" goto fail



:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause

