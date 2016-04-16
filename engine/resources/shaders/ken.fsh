#ifdef GL_ES
	precision highp float;
#endif

varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;
uniform MEDP float timeUniform;

uniform sampler2D sampler;

void main() { 
	gl_FragColor = texture2D ( sampler, uvVarying * timeUniform);
}
