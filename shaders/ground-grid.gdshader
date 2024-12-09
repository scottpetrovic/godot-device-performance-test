shader_type spatial;

uniform vec4 grid_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 base_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float grid_size : hint_range(0.1, 10.0) = 1.0;
uniform float line_thickness : hint_range(0.1, 2) = 0.1;

void fragment() {
    // Get UV coordinates
    vec2 uv = UV;
    
    // Scale UV by grid size
    vec2 scaled_uv = uv / grid_size;
    
    // Create grid lines
    vec2 grid = abs(fract(scaled_uv - 0.5) - 0.5) / fwidth(scaled_uv);
    float line = min(grid.x, grid.y);
    
    // Mix between base color and grid color based on line value
    vec4 final_color = mix(base_color, grid_color, 1.0 - smoothstep(0.0, line_thickness, line));
    
    ALBEDO = final_color.rgb;
}