class_name DebugContent extends Node2D

static var DebugText = "";
var last_debug_text = "";
@export var Debug_Text_Path : NodePath;
@export var Dialogue_Running_Path : NodePath;

func _ready() -> void:
	last_debug_text = "";
	DebugText = "";
	
func _process(delta: float) -> void:
	get_node(Dialogue_Running_Path).visible = DialogueHandler.IsRunning;
	if last_debug_text != DebugText:
		last_debug_text = DebugText;
		get_node(Debug_Text_Path).text = DebugText;
