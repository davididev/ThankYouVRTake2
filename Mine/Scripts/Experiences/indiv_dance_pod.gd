extends Area3D

@export var Mesh_Rend_Path : NodePath;
@export var GlowTouch : Color;
@export var GlowOff : Color;
@export var GlowSoundFX : String = "glowpad.mp3";
@export var GlowSoundFXInverted : String = "glowpadoff.mp3";
@export var GlowPitch : float = 1.0;

var current_glow_color : Color;
var target_glow_color : Color;
const GLOW_LERP_PER_SECOND = 5.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_glow_color = GlowOff;
	target_glow_color = GlowOff;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_glow_color.r = move_toward(current_glow_color.r, target_glow_color.r, GLOW_LERP_PER_SECOND * delta);
	current_glow_color.g = move_toward(current_glow_color.g, target_glow_color.g, GLOW_LERP_PER_SECOND * delta);
	current_glow_color.b = move_toward(current_glow_color.b, target_glow_color.b, GLOW_LERP_PER_SECOND * delta);
	var vs = get_node(Mesh_Rend_Path).get_surface_override_material(0) as ShaderMaterial;
	vs.set_shader_parameter("Glow_Color", current_glow_color);
	get_node(Mesh_Rend_Path).set_surface_override_material(0, vs)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player_body"):
		SoundFXPlayer.PlaySound(GlowSoundFX, get_tree(), global_position, 5.0, 4.0, GlowPitch);
		target_glow_color = GlowTouch;


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player_body"):
		target_glow_color = GlowOff;
		SoundFXPlayer.PlaySound(GlowSoundFXInverted, get_tree(), global_position, 5.0, 4.0, GlowPitch);
