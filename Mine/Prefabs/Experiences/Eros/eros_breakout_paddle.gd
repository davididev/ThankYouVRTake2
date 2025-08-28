class_name BreakoutPaddle extends Node3D

@export var BallPrefab : PackedScene;
@export var dialogue_on_grab : DialogueGrid;
var _ballInstance : BreakoutBall;
var _ranFirst = true;

func _ready() -> void:
	_ranFirst = true;

func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	if _ranFirst == true:
		_ranFirst = false;
		DialogueHandler.Instance.StartDialogue(dialogue_on_grab);


func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	var instTemp = BallPrefab.instantiate();
	instTemp.global_position = global_position;
	get_parent_node_3d().add_child(instTemp);
	_ballInstance = instTemp as BreakoutBall;
	_ballInstance.ForwardVec = -global_basis.z;
	
