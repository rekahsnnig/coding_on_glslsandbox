#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = acos(-1.);
//const float pi2 = 2 * pi;
mat2 rot(float a)
{
	float s = sin(a),c = cos(a);
	return mat2(s,c,-c,s);
}

float dist(vec3 p)
{
	p = mod(p,8.) - 8./2.;
	float len = length(p) - 1.0;
	
	return len;
}

vec3 hsv(float h, float s, float v)
{
	return ((clamp(abs(fract(h+vec3(0.,2.,1.)/3.)*6.-3.)-1.,0.,1.)-1.)*s+1.)*v;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy * 2. - resolution.xy)/min(resolution.x,resolution.y);
	
	float t = time *30.;
	p.xy = p.xy * rot(t* 1./50.);
	vec3 color  = vec3(0.);
	
	vec3 cpos = vec3(0.,0.,-5.);
	vec3 cdir = vec3(0.,0.,1.);
	vec3 cup =  vec3(0.,1.,0.);
	vec3 cside = cross(cdir,cup);
	
	cpos += cdir * t;
	cpos += cup * sin(t * 1./50.) * 10.;
	
	//cpos.xy = cpos.xy * rot(t );
	
	float target = 2.5; 
	vec3 rd = normalize(vec3(p.y * cup+ p.x * cside+cdir * target));
	
	float depth = 0.0;
	float ac = 0.;
	
	for(int i = 0 ; i < 99;  i++)
	{
		vec3 rp = cpos + depth * rd; 
		float len = dist(rp);
		len = max(abs(len),0.01);
		ac += exp(-len*3.);
		depth += len;
	}
	
	color = hsv(ac,0.5,ac/100.);
	//color = vec3(ac);
	gl_FragColor = vec4(color,1.);

}
