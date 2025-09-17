class_name WolfEnem extends RigidBody3D

const MOVE_SPEED = 4.0;
var cam : Camera3D;
@onready var look_at_node := $"CollisionShape3D/LookAtNode";
@export var Health = 40.0;
static var Count = 0;

func _enter_tree() -> void:
	Count += 1;

func _ready() -> void:
	get_node("CollisionShape3D/AnimatedSprite3D").play("default")

func _exit_tree() -> void:
	Count -= 1;

func Damage(amt : float):
	Health -= amt;
	if Health < 0:
		var inst = Node3DPool.GetInstance("BloodExplode");
		if inst != null:
			inst.global_position = global_position;
		queue_free();
	else:
		var inst = Node3DPool.GetInstance("BloodSplatter");
		if inst != null:
			inst.global_position = global_position;

func _physics_process(delta: float) -> void:
	
		
	
	look_at_node.look_at(PosVelCalc.HeadPos);
	var rot = look_at_node.global_rotation_degrees;
	rot.x = 0.0;
	rot.z = 0.0;
	global_rotation_degrees = rot;
	var fwd = -global_basis.z;
	linear_velocity = MOVE_SPEED * fwd;
