shader_type spatial;

render_mode world_vertex_coords, unshaded, depth_draw_never, cull_back;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : hint_default_white, repeat_disable;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform float scale_mod = 1.0;
uniform float cube_half_size = 0.5;

uniform int layer_mask = 1; // Layer mask for filtering
varying mat4 INV_MODEL_MATRIX;

// Function to calculate world position from depth
vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
    float z = depth * 2.0 - 1.0;
    vec4 clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
    vec4 viewSpacePosition = inverse_proj * clipSpacePosition;
    viewSpacePosition /= viewSpacePosition.w;
    vec4 worldSpacePosition = inverse_view * viewSpacePosition;
    return worldSpacePosition.xyz;
}

void vertex() {
    INV_MODEL_MATRIX = inverse(MODEL_MATRIX);
}

void fragment() {
    // Read depth from the depth texture
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
    vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, INV_VIEW_MATRIX);

    // Transform world position into the decal's local space
    vec4 test_pos = INV_MODEL_MATRIX * vec4(world_pos, 1.0);

    // Check if the position is within the decal's bounding box
    if (abs(test_pos.x) > cube_half_size || abs(test_pos.y) > cube_half_size || abs(test_pos.z) > cube_half_size) {
        discard;
    }

    // Apply layer mask filtering
    if ((layer_mask & 1) == 0) {
        discard;
    }

    // Calculate UV coordinates for the decal texture
    vec2 decal_uv = (-test_pos.xz * scale_mod) + 0.5;

    // Sample the decal texture and apply it
    vec4 decal_color = texture(texture_albedo, decal_uv) * albedo;
    ALBEDO = decal_color.rgb;
    ALPHA = decal_color.a;
}