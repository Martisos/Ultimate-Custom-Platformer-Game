shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.5, 0.0, 0.0, 1.0);
uniform float speed = 2.0;

void fragment() {
    float wave = (sin(UV.x * 5.0 - TIME * speed) + 1.0) / 2.0;
    vec4 gradient_color = mix(color1, color2, wave);
    
    vec4 original_text = texture(TEXTURE, UV);
    
    float final_alpha = original_text.a * COLOR.a; 
    
    COLOR = vec4(gradient_color.rgb, final_alpha);
}