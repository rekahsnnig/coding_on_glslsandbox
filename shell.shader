//glslsandbox.com/e#57658.0

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = acos(-1.);
const float pi2 = pi*2.;

mat2 rot(float a)
{
	float c = cos(a) ,s=sin(a);
	return mat2(c,s,-s,c);
}

vec2 pmod(vec2 p , float r)
{
	float a = atan(p.x,p.y) +pi/r;
	float n = pi2 / r;
	a = floor(a/n) * n;
	return p * rot(-a);
}

float sdPlane(vec3 p)
{
	float d = p.y;
	return d;
}

vec3 foldx(vec3 p)
{
	p.x = abs(p.x);
	return p;
}
	
float sdBox(vec3 p , float s)
{
	p = abs(p) - s;
	return max(max(p.x,p.y),p.z);
}
	
float distFunc(vec3 p)
{
	vec3 pp = mod(p,5.) - 8./2.;
	float s= 0.8;
	return sdBox(pp,s);	
}

vec3 hsv(float h,float s,float v)
{
	return ((clamp(abs(fract(h+vec3(0.,2.,1.)/3.)*6.-3.)-1.,0.,1.)-1.)*s+1.)*v;
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy * 2.  -  resolution.xy) / min(resolution.x ,resolution.y) ;
	
	float t = time *6.;
	
	vec3 cpos = vec3(0.,0.,-5.);
	vec3 cup = vec3(0.,1.,0.);
	vec3 cside = normalize(cross(cpos,cup));;
	cpos += vec3(t,t/5.,0.);
	float target = 2.5;
	vec3 rd = normalize(vec3(((1.0 - dot(p,p)) + cside * p.x + cup * p.y)));
	
	rd.xy = pmod(rd.xy,8. * max(0.01,sin(pi/8.*t)));
	
	float transparent = sin(pi/8. * t) * 10.;
	
	vec3 col = vec3(0.0);
	
	float depth = 0.0;
	float c = 0.;
	float ac = 0.;
	for(int i = 0; i < 99 ; i++)	
	{
		vec3 rayPos = cpos + rd* depth;
		float d = distFunc(rayPos);
		d = max(abs(d),0.01 * transparent);
		ac += exp(-d*3.);
		depth += d;
	}
	depth = ac/depth ;
	col = hsv(depth,ac*0.01,depth);
	
	gl_FragColor = vec4(col,1.);
