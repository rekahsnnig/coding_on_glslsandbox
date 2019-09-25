#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = acos(-1.);
const float pi2 = 2. * pi;

mat2 rot(float a)
{
	float s = sin(a) ,c= cos(a);
	return mat2(s,c,-c,s);
	
}

vec2 pmod(vec2 p , float r)
{
	float a = atan(p.x,p.y) + pi/r;
 	float n = pi2/r;
	a = floor(a/n) * n ;
	return p * rot(-a);
}

float box(vec3 p,float s)
{
	p = abs(p) - s;
	return max(max(p.x,p.y),p.z);
}

float sphere(vec3 p)
{
	return length(p) - 0.5;
}
	

float dist(vec3 p)
{
	float t = time * 4.;
	float sep = 8. * sin(t/50.); 
	float w = (sin(t*2.) + 1. )/2.;
	float s = 0.8;
	p = mod(p,8.) - 8./2.;
	p.xy = pmod(p.xy,sep*2.);
	p.yz = pmod(p.yz,sep*4.);
	
	float bo = box(p ,s);
	float sp = sphere(p);
	return mix(bo,sp,w);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy * 2. - resolution.xy )/min(resolution.x,resolution.y);
	
	float t = time * 10.;
	
	p.xy = p.xy * rot(t/40.);
	
	vec3 color = vec3(0.);
	
	
	vec3 cpos = vec3(0.,0.,-5.);
	vec3 cdir = vec3(0.,0.,1.);
	vec3 cup = vec3(0.,1.,0.);
	vec3 cside = cross(cdir,cup);
	
	cpos += 2. *t * cdir * clamp(sin(t*5./2.),1.,0.);
	cpos += sin(t/50.) * 50. * cup;
	cpos += cos(t/100.) * 100. * cside;
	
	float target = 2.5;
	vec3 rd = normalize(vec3(cup * p.y + cside * p.x + cdir * target));
	
	
	
	float depth = 0.0;
	float ac = 0.0;
	
	
	
	for(int i = 0; i < 99 ; i ++)
	{
		vec3 rp = cpos + rd * depth;
		float d = dist(rp);
		d = max(abs(d),0.01);
		ac += exp(-d * 3.);
		depth += d;
		
	}
	
	color = vec3(ac/100.);
	
	gl_FragColor = vec4(color,1.);

}
