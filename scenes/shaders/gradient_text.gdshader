shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform vec4 color2 : source_color = vec4(0.9, 0.9, 0.9, 1.0);
uniform float speed = 2.0;

void fragment() {
    float text_alpha = texture(TEXTURE, UV).a;
    
    float wave = (sin(UV.x * 5.0 + TIME * speed) + 1.0) / 2.0;
    
    vec3 final_color = mix(color1.rgb, color2.rgb, wave);
    
    COLOR = vec4(final_color, text_alpha);
}