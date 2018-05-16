shader_type canvas_item;
render_mode unshaded;

uniform float coeff = 1.0; 

void vertex() {
	
	vec2 u = UV;
	float dist = 0.3 * coeff;
	u.x += sin(2.0 * TIME) * pow(dist, 4.0 + 3.0 * sin(TIME)) / 64.0;
	u.y += sin(3.4 * TIME) * pow(dist, 2.0) / 64.0;
	
	UV.x = u.x;
	UV.y = u.y;
}
