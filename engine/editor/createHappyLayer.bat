::----------------------------------------------------------------::
:: Copyright (c) 2010-2011 Zipline Games, Inc.
:: All Rights Reserved.
:: http://getmoai.com
::----------------------------------------------------------------::

@echo off

:: run moai
"..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createHappyLayer.lua"
copy .\generated\happyLayer.lua ..\resources\layers
:end
pause