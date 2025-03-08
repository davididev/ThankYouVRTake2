extends Node3D

@export var TorusPath : NodePath;
@export var RigidPath : NodePath;
@export var SoundPlayerPath : NodePath;
@export var ParticlePath : NodePath;
const ROTATE_PER_SECOND_1 = 45.0;
const ROTATE_PER_SECOND_2 = 90.0;
var rotate_multiplier = 0.0;
var rotate_multipler_target = 0.0;

func _ready() -> void:
	rotate_multiplier = 0.0;
	rotate_multipler_target = 0.0;
	
func _process(delta: float) -> void:
	get_node(TorusPath).rotate_x(ROTATE_PER_SECOND_1 * delta * rotate_multiplier);
	get_node(TorusPath).rotate_y(ROTATE_PER_SECOND_2 * delta * rotate_multiplier);
	rotate_multiplier = move_toward(rotate_multiplier, rotate_multipler_target, 2.0 * delta);




func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	rotate_multipler_target = 1.0;
	get_node(ParticlePath).emitting = true;
	get_node(SoundPlayerPath).playing = true;


func _on_pickable_object_action_released(pickable: Variant) -> void:
	rotate_multipler_target = 0.0;
	get_node(ParticlePath).emitting = false;
	get_node(SoundPlayerPath).playing = true;
