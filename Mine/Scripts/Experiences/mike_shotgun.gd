class_name MikeShotgun extends Node3D

@onready var scanpoint1 := $"PickableObject/Marker3DA"
@onready var scanpoint2 := $"PickableObject/Marker3DB"
@onready var root := $"PickableObject"
const MAX_DISTANCE = 100.0;
const MIN_DISTANCE = 5.0;  #Min range for damage to be at lower power
const BASE_DAMAGE = 40.0;
var lm : int;


func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	SoundFXPlayer.PlaySound("Wpn_Shotgun_01_Shutter4.wav", get_tree(), root.global_position, 6.0, 20.0, 1.0);
	lm = pow(2, 1-1) + pow(2, 7-1);


func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	SoundFXPlayer.PlaySound("Wpn_Shotgun_02_OneShotTail.wav", get_tree(), root.global_position, 6.0, 20.0, 1.0);
	_fire_from_marker(scanpoint1);
	_fire_from_marker(scanpoint2);
	
func _fire_from_marker(pt : Marker3D):
	var space_state = get_world_3d().direct_space_state;
	var origin = pt.global_position;
	var ending = origin + (pt.global_basis.z * -MAX_DISTANCE);
	var query = PhysicsRayQueryParameters3D.create(origin, ending, lm);
	var result = space_state.intersect_ray(query);
	if result.is_empty() == false:
		var target = result.position;
		var inst = Node3DPool.GetInstance("ShotgunSmoke")
		if inst != null:
			inst.global_position = target;
			
		var n : Node3D = result.collider;
		if n != null:
			var dist = origin.distance_to(target);
			var perc = 1.0;
			if dist > MIN_DISTANCE:
				var min = dist - MIN_DISTANCE;
				var max = MAX_DISTANCE - MIN_DISTANCE;
				perc = perc / (min / max);  #Invert between min and max
			
			if n.has_method("Damage"):
				n.call("Damage", BASE_DAMAGE * perc)
			
