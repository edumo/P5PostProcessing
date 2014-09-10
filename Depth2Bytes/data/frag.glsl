#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
uniform vec4 nearColor = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 farColor = vec4(0.0, 0.0, 0.0, 1.0);
uniform float near = 0.0;
uniform float far = 100.0;
 
varying vec4 vertColor;
 
vec4 packDepth( const in float depth ) {
	const vec4 bitShift = vec4( 16777216.0, 65536.0, 256.0, 1.0 );
	const vec4 bitMask = vec4( 0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0 );
	vec4 res = fract( depth * bitShift );
	res -= res.xxyz * bitMask;
	return res;
}
float unpackDepth(const in vec4 rgba_depth)
{
	const vec4 bit_shift = vec4(1.0/(256.0*256.0*256.0), 1.0/(256.0*256.0), 1.0/256.0, 1.0);
	float depth = dot(rgba_depth, bit_shift);
	return depth;
}

float packColor(vec3 color) {
    return color.r + color.g * 256.0 + color.b * 256.0 * 256.0;
}

vec3 unpackColor(float f) {
    vec3 color;
    color.b = floor(f / 256.0 / 256.0);
    color.g = floor((f - color.b * 256.0 * 256.0) / 256.0);
    color.r = floor(f - color.b * 256.0 * 256.0 - color.g * 256.0);
    // now we have a vec3 with the 3 components in range [0..256]. Let's normalize it!
    return color / 256.0;
}

void main() {
    float depth = mix(nearColor, farColor, smoothstep(near, far, gl_FragCoord.z / gl_FragCoord.w));
    
   // gl_FragColor = vec4(depth,0,1.0,1.0);
   vec3 pack = unpackColor(depth*65536.0);
  // vec3 pack = unpackColor(depth*65536.0);
  //pack.b = 0.0;
   gl_FragColor = vec4(pack,1.0);
}