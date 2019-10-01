#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = acos(-1.);
const float pi2 = pi * 2.;

mat2 rot(float a)
{
	float s = sin(a),c = cos(a);
	return mat2(s,c,-c,s);
}

float dist(vec3 p)
{
	return length(p ) - 0.5;
}

vec3 getNormal(vec3 p)
{
	vec3 d = vec3(0.001,0.,0.);
	return normalize(vec3(
		dist( p + d) - dist(p - d),
		dist( p + d.yxz) - dist(p - d.yxz),
		dist( p + d.zyx) - dist(p - d.zyx)
	));
}

float hash(vec3 p)
{
	return fract(sin(dot(dot(p.x,p.y),p.z)) * 4067.1);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy *2. -  resolution.xy ) /min(resolution.x,resolution.y);
	
	vec2 p2 = ( gl_FragCoord.xy /  resolution.xy );
	
	float zoom = 10.;
	p2 *= zoom * normalize(resolution.xy);
	vec2 id = floor(p2/zoom)*zoom;
	p2 = fract(p2);
	p2 = p2 * 2. - zoom/resolution;
	
	vec3 color =vec3(0.);
	float width = 1.0 - 0.1;
	float pm = -1.;
	color += step(0.,p2.x) * step(p2.x,0.01)
			+step(0.,p2.y) * step(p2.y,0.01);
	color += step((p2.x /p2.y),1.0);
	//color += step(-1.0,(p2.x /p2.y));
	
	float t = time *3.;
	
	vec3 cp = vec3(0.,0.,-5.);
	vec3 cd = vec3(0.,0.,1.);
	vec3 cu = vec3(0.,1.,0.);
	vec3 cs = cross(cu , cd);
	
	float target = 2.5;
	
	vec3 light = vec3(1,-1,2);
	
	vec3 rd = normalize(vec3( cs * p.x + cu * p.y + cd * target));
	
	vec3 normal = vec3(0.);
	float depth = 0.0;
	float star = 0.0;
	vec3 masu = vec3(0.);
	
	/*for(int i = 0; i < 99 ; i++)
	{
		vec3 rp = cp + rd * depth;
		float d = dist(rp);
		
		if(d < 0.01)
		{
			color += vec3(1.);
			normal = getNormal(rp);
			
			break;
		}
		
		
		depth += d;
	}
	*/
//	color += dot(normal , light);
//	color = vec3(p2,0.);
//	color += star;
	//color = vec3(1.) - color;

	gl_FragColor = vec4( color, 1.0 );

}
