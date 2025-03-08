extends Node3D

@export var TorusPath : NodePath;
@export var RigidPath : NodePath;
@export var SoundPlayerPath : NodePath;
@export var ParticlePath : NodePath;
const ROTATE_PER_SECOND_1 = 80.0 * 0.0174533;
const ROTATE_PER_SECOND_2 = 140.0 * 0.0174533;
var rotate_multiplier = 0.0;
var rotate_multipler_target = 0.0;

func _ready() -> void:
	rotate_multiplier = 0.0;
	rotate_multipler_target = 0.0;
	
func _process(delta: float) -> void:
	get_node(TorusPath).rotate_x(ROTATE_PER_SECOND_1 * delta * rotate_multiplier);
	get_node(TorusPath).rotate_y(ROTATE_PER_SECOND_2 * delta * rotate_multiplier);
	rotate_multiplier = move_toward(rotate_multiplier, rotate_multipler_target, 2.0 * delta);

	if is_equal_approx(rotate_multipler_target, 1.0):  #Is running, control pitch
		var bas = get_node(RigidPath).global_basis.x;
		#DebugContent.DebugText = str(round(bas.x), ", ", round(bas.y), ", ", round(bas.z));
		var pitch = bas.x;
		get_node(SoundPlayerPath).pitch_scale = (pitch * 2.0) + 2.0;  #Lowest basis goes is -1, let's make the lowest 0.0



func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	rotate_multipler_target = 1.0;
	get_node(ParticlePath).emitting = true;
	get_node(SoundPlayerPath).playing = true;


func _on_pickable_object_action_released(pickable: Variant) -> void:
	rotate_multipler_target = 0.0;
	get_node(ParticlePath).emitting = false;
	get_node(SoundPlayerPath).playing = false;
