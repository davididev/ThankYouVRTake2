class_name BreakoutBlock extends StaticBody3D

@export_range(0, 3) var StartingHealth := 1;
var currentHealth = 3;
@onready var MeshPath := $"CollisionShape3D/BreakoutBlock/Cube"
@onready var CollisionShape := $"CollisionShape3D";
signal OnEnableNode();
signal Hit();
func _enter_tree() -> void:
	currentHealth = 3;
	

func _setEnabled(en : bool):
	visible = en;
	CollisionShape.set_deferred("disabled", !en);
	currentHealth = StartingHealth;
	_updateColor();
	
func _updateColor():
	var mat = MeshPath.get_surface_override_material(0) as StandardMaterial3D;
	if currentHealth == 1:
		mat.albedo_color = Color.RED;
	if currentHealth == 2:
		mat.albedo_color = Color.GREEN;
	if currentHealth == 3:
		mat.albedo_color = Color.BLUE;
	if currentHealth <= 0:
		var exp = Node3DPool.GetInstance("BlockExplosion");
		if exp != null:
			exp.global_position = global_position + Vector3(0.0, 0.5, 0.0);
		
		_setEnabled(false);

	MeshPath.set_surface_override_material(0, mat);

func _on_on_enable_node() -> void:
	_setEnabled(true);


func _on_hit() -> void:
	currentHealth -= 1;
	if currentHealth > 0:
		var pitch = randf_range(0.8, 1.2);
		SoundFXPlayer.PlaySound("digital/phaserUp7.ogg", get_tree(), global_position, 10.0, 5.5, pitch);
	_updateColor();
