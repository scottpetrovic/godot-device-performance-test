shader_type spatial;

uniform float amplitude : hint_range(0.0, 2.0) = 0.6;    // Wave height
uniform float frequency : hint_range(0.0, 5.0) = 1.0;    // Wave frequency
uniform float speed : hint_range(0.0, 5.0) = 4.0;        // Wave speed
uniform vec4 color : source_color = vec4(0.1, 0.3, 0.8, 1.0);  // Water color

void vertex() {
    vec3 pos = VERTEX;
    float time = TIME * speed;
    
    // First wave - diagonal direction
    float wave1 = sin(time + (pos.x + pos.z) * frequency) * amplitude;
    
    // Second wave - different diagonal direction
    float wave2 = sin(time * 0.8 + (pos.x - pos.z) * frequency * 0.8) * amplitude * 0.6;
    
    // Third wave - circular pattern
    float distance = length(pos.xz);
    float wave3 = sin(time * 1.2 + distance * frequency * 0.7) * amplitude * 0.4;
    
    // Combine waves
    VERTEX.y += wave1 + wave2 + wave3;
    
    // Add a subtle x and z movement for more organic feel
    VERTEX.x += sin(time * 0.5 + pos.z * frequency * 0.3) * amplitude * 0.1;
    VERTEX.z += sin(time * 0.5 + pos.x * frequency * 0.3) * amplitude * 0.1;
}

void fragment() {
    // Simple water-like color with fresnel effect
    float fresnel = pow(1.0 - dot(NORMAL, VIEW), 2.0);
    ALBEDO = color.rgb + fresnel * 0.2;
    SPECULAR = 0.5;
    ROUGHNESS = 0.1;
}