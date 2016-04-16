// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

attribute LOWP vec4 position;
attribute LOWP vec2 uv;
attribute LOWP vec4 color;

varying LOWP vec4 colorVarying;
varying LOWP vec2 uvVarying;

void main () {
    gl_Position = position; 
	uvVarying = uv;
    colorVarying = color;
}
