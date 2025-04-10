shader_type spatial;

render_mode blend_mix, depth_draw_never, cull_back;

uniform sampler2D albedo;
uniform vec4 albedo_tint = vec4(1.0);

uniform sampler2D normal_map;
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
varying mat4 INV_MODEL_MATRIX;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform float cube_half_size = 0.5; // Half-size of the cube for projection
uniform float scale_mod = 1.0; // Scale modifier for UV mapping
uniform int layer_mask = 1; // Layer mask for filtering
uniform int object_layer = 1; // Object's layer passed from the script

void vertex(){
	INV_MODEL_MATRIX = inverse(MODEL_MATRIX);
}
// Function to calculate world position from depth
vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
    float z = depth * 2.0 - 1.0;
    vec4 clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
    vec4 viewSpacePosition = inverse_proj * clipSpacePosition;
    viewSpacePosition /= viewSpacePosition.w;
    vec4 worldSpacePosition = inverse_view * viewSpacePosition;
    return worldSpacePosition.xyz;
}

void fragment() {
    // Read depth from the depth texture
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
    vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, INV_VIEW_MATRIX);

    // Transform world position into the cube's local space
    vec4 test_pos = INV_MODEL_MATRIX * vec4(world_pos, 1.0);

    // Check if the fragment is within the cube's bounds
    if (abs(test_pos.x) > cube_half_size || abs(test_pos.y) > cube_half_size || abs(test_pos.z) > cube_half_size) {
        discard; // Discard fragments outside the cube
    }

    // Apply layer mask filtering
     if ((layer_mask & object_layer) == 0) {
        discard; // Skip rendering if the object's layer does not match the layer mask
    }

    // Calculate UV coordinates for the decal texture
    vec2 decal_uv = (-test_pos.xz * scale_mod) + 0.5;

    // Sample the decal texture
    vec4 decal_color = texture(albedo, decal_uv) * albedo_tint;


    // Apply normal map if enabled
    if (use_normal_map) {
        vec3 normal_tex = texture(normal_map, decal_uv).rgb * 2.0 - 1.0;
        NORMAL = normalize(normal_tex);
    }

    // Apply emission
    //vec4 emission_color = texture(emission, decal_uv) * emission_tint;
    //EMISSION = emission_color.rgb * emission_strength;

    // Apply metallic, roughness, and ambient occlusion
    //METALLIC = texture(metallic, decal_uv).r * metallic_strength;
    //ROUGHNESS = texture(roughness, decal_uv).r * roughness_strength;
    //AO = texture(occlusion, decal_uv).r * occlusion_strength;

    // Apply alpha
    ALPHA = texture(albedo, (-test_pos.xz) + 0.5).a * albedo_tint.a;
	ALBEDO = texture(albedo, (-test_pos.xz)+ 0.5).rgb * albedo_tint.rgb;
}