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
		
	#Allow movement if the rigidbody is moving
	axis_lock_linear_x = !isEnabled;
	axis_lock_linear_y = !isEnabled;
	axis_lock_linear_z = !isEnabled;
	
var reset_timer = 0.0;
var start_timer = 0.0;

func _physics_process(delta: float) -> void:
	var moveRel = Vector3.ZERO;
	var moved = false;
	if reset_timer > 0.0:
		reset_timer -= delta;
		if reset_timer <= 0.0:
			target_progress = 0.0;
	if current_progress != target_progress:
		if start_timer > 0.0:
			start_timer -= delta;
		else:
			current_progress = move_toward(current_progress, target_progress, Move_Multiplier * delta);
			var p = get_node(Follow_Path_Ref) as PathFollow3D;
			p.progress_ratio = sqrt(current_progress) / sqrt(MAX_PROGRESS);
		
			moveRel = p.global_position - global_position;
			moved = true;
		#global_position = p.global_position;
		
		if is_equal_approx(current_progress, target_progress):
			_SetCollisionStatus(false);
			reset_timer = 4.0;
	#linear_velocity = moveRel;
	move_and_collide(moveRel);



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		target_progress = MAX_PROGRESS;
		start_timer = 0.05;  #A short delay before you start to avoid glitches
		_SetCollisionStatus(true);


func _on_area_3d_body_exited(body: Node3D) -> void:
	pass;
