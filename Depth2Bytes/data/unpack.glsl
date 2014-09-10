#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float unpackDepth(const in vec4 rgba_depth)
{
	const vec4 bit_shift = vec4(1.0/(256.0*256.0*256.0), 1.0/(256.0*256.0), 1.0/256.0, 1.0);
	float depth = dot(rgba_depth, bit_shift);
	return depth;
}

float packColor(vec3 color) {
    return color.r + color.g * 256.0 + color.b * 256.0 * 256.0;
}

void main(void) {
  
  float depth = packColor(texture2D(texture,vertTexCoord.st ).abg) / 65536.0;
  //float depth = packColor(texture2D(texture,vertTexCoord.st ).bgr) / 65536.0;

  gl_FragColor = vec4(depth,depth,depth,1.0); 
}