class_name Eros_Zipline extends Node3D

@export var Path_Follow_3D_Ref : NodePath;
@export var Move_Multiplier = 10.0;
var current_progress = 0.0;
var target_progress = 0.0;


const MAX_PROGRESS = 100.0;

func _ready() -> void:
	current_progress = 0.0;
	target_progress = 0.0;
	
func _process(delta: float) -> void:
	if current_progress != target_progress:
		current_progress = move_toward(current_progress, target_progress, Move_Multiplier * delta);
		var p = get_node(Path_Follow_3D_Ref) as PathFollow3D;
		p.progress = sqrt(current_progress)
		global_position = p.global_position;


func _on_Grab(pickable: Variant, grab_point: Variant) -> void:
	target_progress = MAX_PROGRESS;


func _On_Release(pickable: Variant, grab_point: Variant) -> void:
	target_progress = 0.0;
