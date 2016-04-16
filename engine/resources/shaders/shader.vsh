uniform mat4 transform;

attribute MEDP vec4 position;
attribute LOWP vec2 uv;
attribute LOWP vec4 color;

varying LOWP vec2 uvVarying;

void main () {
    gl_Position = position * transform; 
	uvVarying = uv;
}
