@echo off

GenCase4_win64.exe>GenCase4_Help.out
GenCase4_win64.exe -template
DualSPHysics4_win64.exe>DualSPHysics4_Help.out
BoundaryVTK4_win64.exe>BoundaryVTK4_Help.out
PartVTK4_win64.exe>PartVTK4_Help.out
PartVTKOut4_win64.exe>PartVTKOut4_Help.out
MeasureTool4_win64.exe>MeasureTool4_Help.out
MeasureTool4_win64.exe -pointstemplate
ComputeForces4_win64.exe>ComputeForces4_Help.out
FloatingInfo4_win64.exe>FloatingInfo4_Help.out
IsoSurface4_win64.exe>IsoSurface4_Help.out

:success
echo All done
goto end

:fail
echo Execution aborted.

:end
pause
