class_name PathElevator extends RigidBody3D

@export var Follow_Path_Ref : NodePath;
@export var Move_Multiplier = 5.0;
@export var Wall_Meshes : Array[NodePath];
@export var Wall_Colliders : Array[NodePath];

var current_progress = 0.0;
var target_progress = 0.0;


const MAX_PROGRESS = 100.0;


func _ready() -> void:
	_SetCollisionStatus(false);

func _SetCollisionStatus(isEnabled : bool):
	for np in Wall_Colliders:
		var co = get_node(np) as CollisionShape3D;
		co.set_deferred("disabled", !isEnabled)
	for np in Wall_Meshes:
		var mi = get_node(np) as MeshInstance3D;
		mi.visible = isEnabled;

func _process(delta: float) -> void:
	if current_progress != target_progress:
		current_progress = move_toward(current_progress, target_progress, Move_Multiplier * delta);
		var p = get_node(Follow_Path_Ref) as PathFollow3D;
		p.progress_ratio = sqrt(current_progress) / sqrt(MAX_PROGRESS);
		
		if is_equal_approx(current_progress, target_progress):
			_SetCollisionStatus(false);


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		target_progress = MAX_PROGRESS;
		_SetCollisionStatus(true);


func _on_area_3d_body_exited(body: Node3D) -> void:
	await get_tree().create_timer(2.0).timeout;
	target_progress = 0.0;
