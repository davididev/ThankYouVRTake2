class_name HannahLaserGun extends Node3D

signal OnBulletDamage(amount : int, type : int);  #Template for things that interact with bullet
#Type is going to be 0 for left hand, 1 for right hand

@export var GunType = 0;
@export var HannahLaserPath : NodePath;
@export var EndingParticlePath : NodePath;
var StartingPos : Vector3;
var lm = 0;
var isFiring = false;

func _ready() -> void:
	get_node(HannahLaserPath).visible = false;
	lm = pow(2.0, 1-1) + pow(2.0, 7-1);  #Layers 1 and 7 (static and enemies)
	isFiring = false;
	StartingPos = global_position;
	
func _process(delta: float) -> void:
	get_node(HannahLaserPath).visible = isFiring;
	if isFiring:
		var space_state = get_world_3d().direct_space_state;
		var origin = get_node(HannahLaserPath).global_position;
		var end = origin + (get_node(HannahLaserPath).global_basis.z * -10.0);
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collision_mask = lm;
		var result = space_state.intersect_ray(query);
		if result.is_empty() == false:
			end = result.position;
			if result.collider.has_signal("OnBulletDamage"):
				result.collider.emit_signal("OnBulletDamage", 1, GunType);
		
		var dist = origin.distance_to(end);
		var temp_scale = get_node(HannahLaserPath).scale;
		temp_scale.z = dist;
		get_node(HannahLaserPath).scale = temp_scale;
		get_node(EndingParticlePath).global_position = end;
	

func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	isFiring = true;
	get_node(EndingParticlePath).emitting = true;


func _on_pickable_object_action_released(pickable: Variant) -> void:
	isFiring = false;
	get_node(EndingParticlePath).emitting = false;
