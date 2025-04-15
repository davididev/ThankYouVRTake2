class_name HannahTarget extends RigidBody3D

@export var MyType = 0;
@export var ExplosionPrefabName = "Explosion1"
const MIN_SCALE = 0.01;
const MAX_SCALE = 1.0;
const HITTABLE_SCALE = 0.9;
var current_scale = MIN_SCALE;
var target_scale = MAX_SCALE;
var timer_shrink = 0.0;

const SCALE_TOTAL_TIME = 0.75;
const SCALE_PER_SECOND = 1.0 / SCALE_TOTAL_TIME;  #Scale 1x per 0.45 seconds
const MOVE_DISTANCE = 1.25;
const MOVE_PER_SECOND = MOVE_DISTANCE / SCALE_TOTAL_TIME;
var targetZ = 0;

signal OnBulletDamage(amount : int, type : int);  #Template for things that interact with bullet
signal EnablePool();
signal DisablePool();

var canHit = false;

func _on_enable_pool() -> void:
	get_node("CollisionShape3D").call_deferred("set_disabled", false);
	canHit = false
	timer_shrink = 0.0;
	current_scale = MIN_SCALE;
	target_scale = MAX_SCALE;
	scale = Vector3.ONE * current_scale;
	targetZ = position.z + MOVE_DISTANCE;
	HannahMusicController.TotalTargets += 1;
	
func _process(delta: float) -> void:
	if not is_equal_approx(current_scale, target_scale):
		current_scale = move_toward(current_scale, target_scale, SCALE_PER_SECOND * delta);
		scale = Vector3.ONE * current_scale;
	if is_equal_approx(current_scale, MIN_SCALE):
		Node3DPool.SetActive(self, false);

	var tpos = position;
	tpos.z = move_toward(tpos.z, targetZ, MOVE_PER_SECOND * delta);
	position = tpos;

	if is_equal_approx(current_scale, MAX_SCALE):
		timer_shrink += delta;
		if timer_shrink > 0.5:
			target_scale = MIN_SCALE;
			current_scale -= delta;

func _on_disable_pool() -> void:  #Not sure if I need something here yet.
	get_node("CollisionShape3D").call_deferred("set_disabled", true);


func _on_on_bullet_damage(amount: int, type: int) -> void:
	if current_scale < HITTABLE_SCALE:
		return;
		
	if type == MyType:
		HannahMusicController.HitTargets += 1;
	
	var explosion = Node3DPool.GetInstance(ExplosionPrefabName);
	explosion.position = position;
	Node3DPool.SetActive(self, false);
	if MyType == 2:
		var nodes = get_tree().get_nodes_in_group(&"Target");
		for n in nodes:
			Node3DPool.SetActive(n, false);
