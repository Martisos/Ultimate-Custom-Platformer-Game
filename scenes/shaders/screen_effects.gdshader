shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform bool mirror_x = false;
uniform bool grayscale = false;
uniform bool invert_colors = false;

void fragment() {
	vec2 uv = SCREEN_UV;
	
	if(mirror_x) {
		uv.x = 1.0 - uv.x;
	}
	
	COLOR = texture(screen_texture, uv);
}
