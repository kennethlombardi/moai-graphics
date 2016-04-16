#ifdef GL_ES
	precision highp float;
#endif

attribute LOWP vec4 position;
attribute LOWP vec2 uv;
varying LOWP vec2 uvVarying;

void main () {
	gl_Position = position;
	uvVarying = uv;
}
