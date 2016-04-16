
@echo off

:: run moai
"..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createTempleLayer.lua"
copy .\generated\templeLayer.lua ..\resources\layers
:end
pause