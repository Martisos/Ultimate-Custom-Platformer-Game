shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform bool mirror_x = false;
uniform bool grayscale = false;
uniform bool invert_colors = false;
uniform bool zoom_blur = false;
uniform vec2 zoom_center = vec2(0.5, 0.5);
uniform int layers = 5;
uniform float opacity = 0.5;
uniform float original_opacity_mod : hint_range(0.0, 1.0) = 0.0;
uniform float zoom = 0.25;
uniform float normalization : hint_range(0.0, 1.0) = 1.0;
uniform float normalized_scale : hint_range(-1.0, 1.0) = 0.01;

uniform bool glitch_active = false;
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.5;

vec2 adj_uv(vec2 a_uv, float a_scale, vec2 a_pivot) {
	return a_pivot + (a_uv - a_pivot) * pow(a_scale, -1.0);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	if (mirror_x) {
		uv.x = 1.0 - uv.x;
	}
	if (glitch_active) {
		float shake = (rand(vec2(TIME, uv.y)) - 0.5) * 0.05 * glitch_intensity;
		if (rand(vec2(TIME, floor(uv.y * 20.0))) > 0.8) {
			uv.x += shake;
		}
	}
	
	vec4 color = texture(screen_texture, uv);
	
	if (zoom_blur) {
		vec4 out_color = color;
		for (int iter = 1; iter < layers + 1; iter++) {
			vec2 adjusted_uv = adj_uv(uv, 1.0 + (zoom * float(iter)), zoom_center);
			vec2 adjusted_vector = adjusted_uv - uv;
			vec2 zoom_vector = (zoom_center - uv);
			vec2 norm_dir = length(zoom_vector) > 0.0001 ? normalize(zoom_vector) : vec2(0.0);
			vec2 normalized_vector = norm_dir * float(iter) * normalized_scale;
			zoom_vector = mix(adjusted_vector, normalized_vector, normalization);
			vec4 sample_color = texture(screen_texture, clamp(zoom_vector + uv, vec2(0.001), vec2(0.999)));
			float opacity_mod = 1.0 - (color.a * original_opacity_mod);
			out_color = mix(out_color, sample_color, sample_color.a * pow(opacity, float(iter)) * opacity_mod);
		}
		color = out_color;
	}
	
	if (glitch_active) {
		float offset = 0.02 * glitch_intensity;
		color.r = texture(screen_texture, vec2(uv.x + offset, uv.y)).r;
		color.b = texture(screen_texture, vec2(uv.x - offset, uv.y)).b;
	}
	
	if (grayscale) {
		float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		color.rgb = vec3(gray);
	}
	if (invert_colors) {
		color.rgb = vec3(1.0) - color.rgb;
	}
	
	COLOR = color;
}