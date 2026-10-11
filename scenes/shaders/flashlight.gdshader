shader_type canvas_item;
uniform vec2 mouse_position;
uniform vec2 screen_size;

uniform float radius = 150.0;
uniform float softness = 50.0;

uniform vec4 darkness_color : source_color = vec4(0.0, 0.0, 0.0, 0.98);

void fragment() {
	vec2 pixel_coord = UV * screen_size;
	float dist = distance(pixel_coord, mouse_position);
	float alpha = smoothstep(radius, radius + softness, dist);
	COLOR = vec4(darkness_color.rgb, darkness_color.a * alpha);
}