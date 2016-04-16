@echo off

:: run moai
"..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createBunniesLayer.lua"
copy .\generated\bunniesLayer.lua ..\resources\layers
:end
pause