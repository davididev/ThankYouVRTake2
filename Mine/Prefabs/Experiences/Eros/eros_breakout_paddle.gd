class_name BreakoutPaddle extends Node3D

@export var BallPrefab : PackedScene;
@export var dialogue_on_grab : DialogueGrid;
@onready var _root := $"PickableObject"
@onready var _spawn_point := $"PickableObject/FirePoint"
signal OnEnableNode();
var _ballInstance : BreakoutBall;
var _ranFirst = true;
var startingPos : Vector3;

func _ready() -> void:
	_ranFirst = true;
	startingPos = _root.position;

func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	if _ranFirst == true:
		_ranFirst = false;
		DialogueHandler.Instance.StartDialogue(dialogue_on_grab);


func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	if _ballInstance == null:
		var instTemp = BallPrefab.instantiate();
		var v = _spawn_point.global_position;
		instTemp.global_position = v;
		get_parent_node_3d().add_child(instTemp);
		_ballInstance = instTemp as BreakoutBall;
		_ballInstance.ForwardVec = -_root.global_basis.z;
	


func _on_pickable_object_body_entered(body: Node) -> void:
	var node = body as Node3D;
	if node != null:
		if node.name == "ErosBreakoutBall":
			_ballInstance.ForwardVec = -_root.global_basis.z;


func _on_on_enable_node() -> void:
	if _ballInstance != null:
		_ballInstance.queue_free()
	_root.position = startingPos;
	
