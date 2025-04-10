class_name TimTarget extends RigidBody3D
signal OnBulletDamage(amount : int, type : int);  #Template for things that interact with bullet
@export var points = 0;
@export var explosionID = 0;
@export var Lifetime = 10.0;
@export var ExplosionPrefab : PackedScene;
var current_scale = 0.01;
var target_scale = 1.0;

func _ready() -> void:
	current_scale = 0.1;
	target_scale = 1.0;
	scale = Vector3.ONE * current_scale;
	
func _process(delta: float) -> void:
	look_at(PosVelCalc.HeadPos, Vector3.UP, true);
	current_scale = move_toward(current_scale, target_scale, 0.5 * delta);
	scale = Vector3.ONE * current_scale;
	Lifetime -= delta;
	if Lifetime <= 0.0:
		target_scale = 0.01;
		if is_equal_approx(current_scale, target_scale):
			queue_free();

func _on_on_bullet_damage(amount: int, type: int) -> void:
	LightningChainGun.Score += points;
	var inst = ExplosionPrefab.instantiate();
	inst.position = Vector3.ZERO;
	SoundFXPlayer.PlaySound("scifi/explosionCrunch_000.ogg", get_tree(), global_position, 5.0);
	get_parent().add_child(inst);
	queue_free();
