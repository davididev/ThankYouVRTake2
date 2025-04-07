class_name BulletInstance extends Area3D

@export var ForwardVelocity = 5.0;
@export var DamageAmount = 1;
@export var DamageType = 0;
@export var ExplosionPrefab : PackedScene;
@export var SoundOnSpawn : String = "scifi/Sound.wav"
signal OnBulletDamage(amount : int, type : int);  #Template for things that interact with bullet

func _ready() -> void:
	SoundFXPlayer.PlaySound(SoundOnSpawn, get_tree(), global_position, 4.0, 10.0)
	top_level = true;

func _process(delta: float) -> void:
	
	var pos = global_position;
	pos = pos - (basis.z * ForwardVelocity * delta);
	global_position = pos;
	


func _on_body_entered(body: Node3D) -> void:
	if body.has_signal("OnBulletDamage"):
		body.emit_signal("OnBulletDamage", DamageAmount, DamageType);
	
	queue_free();
