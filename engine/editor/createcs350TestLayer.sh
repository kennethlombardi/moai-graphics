#!/bin/bash
# ::----------------------------------------------------------------::
# :: Copyright (c) 2010-2011 Zipline Games, Inc.
# :: All Rights Reserved.
# :: http://getmoai.com
# ::----------------------------------------------------------------::

# "..\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createcs350TestLayer.lua"
# copy .\generated\cs350TestLayer.lua ..\resources\layers

${MOAI_BIN}/moai editor/createcs350TestLayer.lua
cp editor/generated/cs350TestLayer.lua resources/layers
