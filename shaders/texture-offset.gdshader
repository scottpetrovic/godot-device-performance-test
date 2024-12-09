shader_type spatial;

uniform sampler2D tex : source_color;
uniform vec2 scroll_speed = vec2(0.5, 0.3);  // X and Y scroll speeds
uniform vec2 tiling = vec2(2.0, 2.0);        // How many times to repeat the texture

void fragment() {
    // Get UV coordinates and scale them by tiling amount
    vec2 base_uv = UV * tiling;
    
    // Create scrolling effect based on time
    vec2 moving_uv = base_uv + (TIME * scroll_speed);
    
    // Sample the texture with our modified UVs
    vec4 tex_color = texture(tex, moving_uv);
    
    ALBEDO = tex_color.rgb;
}