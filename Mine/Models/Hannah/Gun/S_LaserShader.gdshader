shader_type spatial;
render_mode blend_add;

uniform vec4 albedo_color; // Albedo color
uniform vec4 fresnel_color; // Fresnel glow color
uniform float fresnel_power : hint_range(0.0, 10.0); // Fresnel intensity
uniform float distortion_strength : hint_range(0.0, 1.0); // Fresnel distortion strength
uniform float time_scale : hint_range(0.0, 10.0); // Speed of distortion

void fragment() {
    // Calculate Fresnel effect
    float fresnel = pow(1.0 - abs(dot(NORMAL, vec3(0.0, 0.0, 1.0))), fresnel_power);

    // Apply distortion to the Fresnel effect
    float distortion = distortion_strength * cos(TIME * time_scale + SCREEN_UV.x * 10.0 + SCREEN_UV.y * 10.0);
    fresnel += distortion;

    // Clamp Fresnel to avoid negative values
    fresnel = clamp(fresnel, 0.0, 1.0);

    // Combine albedo and distorted Fresnel glow
    vec4 color = albedo_color + fresnel_color * fresnel;

    // Output final color
    ALBEDO = color.rgb;
    ALPHA = color.a;
}