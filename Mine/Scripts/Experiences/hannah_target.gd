class_name HannahTarget extends RigidBody3D

@export var MyType = 0;
@export var ExplosionPrefabName = "Explosion1"
const MIN_SCALE = 0.01;
const MAX_SCALE = 1.0;
var current_scale = MIN_SCALE;
var target_scale = MAX_SCALE;
var timer_shrink = 0.0;

const SCALE_TOTAL_TIME = 0.5;
const SCALE_PER_SECOND = (MAX_SCALE - MIN_SCALE) / SCALE_TOTAL_TIME;  #Scale 1x per 0.45 seconds
const MOVE_DISTANCE = 1.0;
const MOVE_PER_SECOND = MOVE_DISTANCE / SCALE_TOTAL_TIME;
var remaining_X = 0;

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
	remaining_X = MOVE_DISTANCE;
	if MyType < 2:  #Added this in so mines don't contribute to the accuracy
		HannahMusicController.TotalTargets += 1;
		HannahScoreCanvas.Update = true;
	
func _process(delta: float) -> void:
	if not is_equal_approx(current_scale, target_scale):
		current_scale = move_toward(current_scale, target_scale, SCALE_PER_SECOND * delta);
		scale = Vector3.ONE * current_scale;
	if is_equal_approx(current_scale, MIN_SCALE):
		Node3DPool.SetActive(self, false);

	var tpos = position;
	var moveDelta = MOVE_PER_SECOND * delta;
	if moveDelta > remaining_X:
		moveDelta = remaining_X;
		
	remaining_X -= moveDelta;
	tpos.x -= moveDelta;
	position = tpos;

	if is_equal_approx(current_scale, MAX_SCALE):
		timer_shrink += delta;
		if timer_shrink > 0.5:
			target_scale = MIN_SCALE;
			current_scale -= delta;

func _on_disable_pool() -> void:  #Not sure if I need something here yet.
	get_node("CollisionShape3D").call_deferred("set_disabled", true);


func _on_on_bullet_damage(amount: int, type: int) -> void:
	
	if not is_equal_approx(remaining_X, 0.0):  #Hasn't reached the target point
		return;
		
	if type == MyType:
		HannahMusicController.HitTargets += 1;
		Explode();
	if MyType < 2 and type != MyType:
		Explode();

	HannahScoreCanvas.Update = true;	
	
	if MyType == 2:
		var nodes = get_tree().get_nodes_in_group("Target");
		for n in nodes:
			if n.visible == true:
				if n.has_method("Explode"):
					n.call("Explode");
			
func Explode():
	var explosion = Node3DPool.GetInstance(ExplosionPrefabName);
	explosion.position = position;
	Node3DPool.SetActive(self, false);	
