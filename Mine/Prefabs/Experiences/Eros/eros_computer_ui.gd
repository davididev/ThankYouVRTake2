class_name EricComputerUI extends Control

static var CurrentExperience = -1;

@export var Panels : Array[NodePath];

var current_panel = 0;
func _setPanel(pid : int):
	for i in range(0, Panels.size()):
		get_node(Panels[i]).visible = (pid == i);
	current_panel = pid;
func _ready() -> void:
	_setPanel(0);


func _on_button_zipline_pressed() -> void:
	CurrentExperience = 0;
	ErosComputer.InitLoad = true;
	_setPanel(1);


func _on_button_breakout_pressed() -> void:
	CurrentExperience = 1;
	ErosComputer.InitLoad = true;
	_setPanel(1);


func _on_button_boxing_pressed() -> void:
	CurrentExperience = 2;
	ErosComputer.InitLoad = true;
	_setPanel(1);

func _process(delta: float) -> void:
	#Wait for Eros_computer to say 
	if current_panel == 1:  #Program loading panel
		if ErosComputer.IsLoading == false and ErosComputer.InitLoad == false:
			_setPanel(2);


func _on_button_unload_pressed() -> void:
	ErosComputer.UnloadNow = true;
	_setPanel(0);
