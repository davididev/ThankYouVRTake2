class_name CylindarDoorTransition extends StaticBody3D

var is_visible_by_player = false;
var player_is_in_field = false;
@export var SceneName = "Mine/Scenes/Tim.tscn";
const SOUND_OPEN = "afv_open door.mp3";
const SOUND_CLOSE = "afv_close door.mp3";
@export var Position_To_Go = Vector3.ZERO;
@export var Doorways : Array[NodePath];

var door_shape_target = 0.0;
var door_shape_current = 0.0;
const DOOR_SHAPE_PER_SECOND = 5.0;
var currently_transitioning = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_visible_by_player = false;
	player_is_in_field = false;
	currently_transitioning = false;
	door_shape_target = 0.0;
	door_shape_current = 0.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_equal_approx(door_shape_current, door_shape_target):
		door_shape_current = move_toward(door_shape_current, door_shape_target, DOOR_SHAPE_PER_SECOND * delta);
		for np in Doorways:
			get_node(np).set_blend_shape_value(0, door_shape_current);
	
	if is_equal_approx(door_shape_current, 1.0):
		if player_is_in_field:
			if not currently_transitioning:
				var args : Array[String];
				args.append(SceneName);
				args.append(str(Position_To_Go.x, ",", Position_To_Go.y, ",", Position_To_Go.z));
				DialogueHandler.Instance.SteamTeleport(args);
				currently_transitioning = true;
	
func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	is_visible_by_player = true;


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	is_visible_by_player = false;


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		player_is_in_field = true;
		SoundFXPlayer.PlaySound(SOUND_OPEN, get_tree(), global_position, 15.0, 2.0);
		door_shape_target = 1.0;

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		player_is_in_field = false;
		SoundFXPlayer.PlaySound(SOUND_CLOSE, get_tree(), global_position, 15.0, 2.0);
		door_shape_target = 0.0;
