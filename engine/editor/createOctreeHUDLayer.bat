
@echo off

:: run moai
"..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createOctreeHUDLayer.lua"
copy .\generated\OctreeHUDLayer.lua ..\resources\layers
:end
pause