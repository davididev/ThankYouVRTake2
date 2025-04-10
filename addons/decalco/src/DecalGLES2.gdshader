shader_type spatial;

render_mode blend_mix, depth_draw_never, cull_back;

uniform sampler2D albedo;
uniform vec4 albedo_tint = vec4(1.0);

uniform sampler2D normal_map : hint_normal;
uniform bool use_normal_map = false;

uniform sampler2D emission;
uniform vec4 emission_tint = vec4(vec3(0.0), 1.0);
uniform float emission_strength = 1.0;

uniform sampler2D metallic;
uniform float metallic_strength = 1.0;

uniform sampler2D roughness;
uniform float roughness_strength = 1.0;

uniform sampler2D occlusion;
uniform float occlusion_strength = 1.0;
uniform int layer_mask = 1;  // Define the layer mask as a uniform
void fragment() {
    vec2 uv = UV;

	 if ((layer_mask & 1) == 0) {
        discard;  // Skip rendering if the layer doesn't match
    }

    // Albedo
    vec4 albedo_color = texture(albedo, uv) * albedo_tint;
    ALBEDO = albedo_color.rgb;

    // Normal Map
    if (use_normal_map) {
        vec3 normal_tex = texture(normal_map, uv).rgb * 2.0 - 1.0;
        NORMAL = normalize(normal_tex);
    }

    // Emission
    vec4 emission_color = texture(emission, uv) * emission_tint;
    EMISSION = emission_color.rgb * emission_strength;

    // Metallic
    METALLIC = texture(metallic, uv).r * metallic_strength;

    // Roughness
    ROUGHNESS = texture(roughness, uv).r * roughness_strength;

    // Ambient Occlusion
    AO = texture(occlusion, uv).r * occlusion_strength;

    // Alpha
    ALPHA = albedo_color.a;
}