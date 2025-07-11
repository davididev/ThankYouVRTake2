class_name LightningChainGun extends Node3D

static var HoldingGun = false;
var holdCount = 0;
var target_rotate_multiplier = 0.0;
var current_rotate_multiplier = 0.0;
const ROTATE_MULTI_PER_SECOND = 0.5;
static var Score = 0;
var isFiring = false;
var fire_timer = 0.0;
const FIRE_RATE = 0.1;
@export var BulletPrefab : PackedScene;
var instance;

func _ready() -> void:
	holdCount = 0;
	instance = BulletPrefab.instantiate();  #preload for the first time
	HoldingGun = false;
	isFiring = false;
	target_rotate_multiplier = 0.0;
	current_rotate_multiplier = 0.0;
	get_node("PickableObject/CollisionShape3D/Viewport2Din3D").visible = false;
	
func _process(delta: float) -> void:
	if not is_equal_approx(target_rotate_multiplier, current_rotate_multiplier):
		current_rotate_multiplier = move_toward(current_rotate_multiplier, target_rotate_multiplier, ROTATE_MULTI_PER_SECOND * delta);
		get_node("PickableObject/CollisionShape3D/LightningChainGun/Cores_009").Multiplier = current_rotate_multiplier;

	if isFiring:
		fire_timer += delta;
		if fire_timer >= FIRE_RATE:
			fire_timer = 0.0;
			
			instance = BulletPrefab.instantiate();
			get_parent().add_child(instance);
			instance.global_position = get_node("PickableObject/CollisionShape3D/FirePoint").global_position;
			instance.global_rotation = get_node("PickableObject/CollisionShape3D/FirePoint").global_rotation;

func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	target_rotate_multiplier = 1.0;
	isFiring = true;


func _on_pickable_object_action_released(pickable: Variant) -> void:
	target_rotate_multiplier = 0.0;
	isFiring = false;





func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	holdCount += 1;
	if holdCount > 0:
		HoldingGun = true;
		Score = 0;
		get_node("PickableObject/CollisionShape3D/Viewport2Din3D").visible = true;


func _on_pickable_object_dropped(pickable: Variant) -> void:
	holdCount -= 1;
	if holdCount <= 0:
		HoldingGun = false;
		get_node("PickableObject/CollisionShape3D/Viewport2Din3D").visible = false;
