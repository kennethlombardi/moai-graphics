
varying MEDP vec2 uvVarying;
uniform sampler2D sampler;
varying LOWP vec4 colorVarying;
uniform vec4 maskColor;

void main() {
	gl_FragColor = maskColor; //colorVarying + maskColor;
}
