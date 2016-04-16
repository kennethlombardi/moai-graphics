#ifdef GL_ES
	precision highp float;
#endif

varying MEDP vec2 uvVarying;

uniform sampler2D sampler;

void main() { 
	gl_FragColor = texture2D ( sampler, uvVarying);
}
