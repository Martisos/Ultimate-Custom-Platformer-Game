shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

//mirror
uniform bool mirror_x = false;

//random shader
uniform bool grayscale = true;
uniform bool invert_colors = false;

void fragment() {
	vec2 uv = SCREEN_UV;
	
	if(mirror_x) {
		uv.x = 1.0 - uv.x;
	}
	
	 vec4 color = texture(screen_texture, uv);
	
	if(grayscale) {
		float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		color.rgb = vec3(gray);
	}
	
	if(invert_colors) {
		color.rgb = vec3(1.0) - color.rgb;
	}
	
	COLOR = color;
}
