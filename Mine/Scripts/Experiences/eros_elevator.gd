class_name PathElevator extends RigidBody3D

@export var Follow_Path_Ref : NodePath;
@export var Move_Speeds : Array[float];
@export var Wall_Meshes : Array[NodePath];
@export var Wall_Colliders : Array[NodePath];

var current_path_id = 0;
var target_path_id = 0;
const PLAYER_SAFE_MARGIN = 0.08;

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
		
	#Allow movement if the rigidbody is moving
	axis_lock_linear_x = !isEnabled;
	axis_lock_linear_y = !isEnabled;
	axis_lock_linear_z = !isEnabled;
	
var reset_timer = 0.0;
var start_timer = 0.0;
var moveRel = Vector3.ZERO;

func _physics_process(delta: float) -> void:
	moveRel = Vector3.ZERO;
	var moved = false;
	if reset_timer > 0.0:
		reset_timer -= delta;
		if reset_timer <= 0.0:
			target_path_id = 0;
			
		var p = get_node(Follow_Path_Ref) as Path3D;
		var vec = p.to_global(p.curve.get_point_in(current_path_id))
		var target_pos = global_position.move_toward(vec, Move_Speeds[current_path_id] * delta);
		moveRel = global_position - target_pos;
		if moveRel.length() < PLAYER_SAFE_MARGIN:
			moved = false;
			if current_path_id < target_path_id:
				current_path_id += 1;
			if current_path_id > target_path_id:
				target_path_id -= 1;
		else:
			moved = true;
		#global_position = p.global_position;
		
		if is_equal_approx(current_path_id, target_path_id):
			_SetCollisionStatus(false);
			reset_timer = 4.0;
	#linear_velocity = moveRel;
	if moved:
		move_and_collide(moveRel);
	
	
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_zero_approx(target_path_id):
		if body.is_in_group("player_body"):
			var p = get_node(Follow_Path_Ref) as Path3D;
			target_path_id = p.curve.point_count;
			start_timer = 0.05;  #A short delay before you start to avoid glitches
			_SetCollisionStatus(true);


func _on_area_3d_body_exited(body: Node3D) -> void:
	pass;
