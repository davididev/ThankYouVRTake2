class_name MikeShotgun extends Node3D

@onready var scanpoint1 := $"PickableObject/Marker3DA"
@onready var scanpoint2 := $"PickableObject/Marker3DB"
@onready var root := $"PickableObject"
const MAX_DISTANCE = 100.0;
const MIN_DISTANCE = 4.0;  #Min range for damage to be at bade
const BASE_DAMAGE = 20.0;


func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	SoundFXPlayer.PlaySound("Wpn_Shotgun_01_Shutter4.wav", get_tree(), root.global_position, 6.0, 20.0, 1.0);


func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	SoundFXPlayer.PlaySound("Wpn_Shotgun_02_OneShotTail.wav", get_tree(), root.global_position, 6.0, 20.0, 1.0);
