class_name PlayParticlesOnceV2 extends Node3D

@export var overall_lifetime = 5.0;
@export var PlaySound = "File.mp3";
var lifespan_passed = 0.0;
signal EnablePool();
signal DisablePool();



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifespan_passed -= delta;
	if lifespan_passed < 0.0:
		Node3DPool.SetActive(self, false);


func _on_enable_pool() -> void:
	lifespan_passed = overall_lifetime;
	for child in get_children():
		if child is GPUParticles3D:
			child.emitting = true;

	if not PlaySound.is_empty():
		SoundFXPlayer.PlaySound(PlaySound, get_tree(), global_position, 6.0);

func _on_disable_pool() -> void:
	pass # Replace with function body.
