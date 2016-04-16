::----------------------------------------------------------------::
:: Copyright (c) 2010-2011 Zipline Games, Inc.
:: All Rights Reserved.
:: http://getmoai.com
::----------------------------------------------------------------::

@echo off

:: run moai
"..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createBVHHUDLayer.lua"
copy .\generated\BVHHUDLayer.lua ..\resources\layers
:end
pause