class_name ErosComputer extends StaticBody3D

@export var Experience_Paths : Array[NodePath];
static var IsLoading = false;
static var InitLoad = false;
static var UnloadNow = false;

@export var BarrierNodes : Array[NodePath]

func _SetBarrierDisabled(dis : bool):
	for np in BarrierNodes:
		get_node(np).set_deferred("disabled", dis);

var last_loading = false;

func _ready() -> void:
	last_loading = false;
	EricComputerUI.CurrentExperience = -1;
	IsLoading = false;
	InitLoad = false;
	UnloadNow = false;

func _process(delta: float) -> void:  
	#If Loading is set to true, move the experience up until it hits the target
	if InitLoad == true:  #First step of loading
		for i in range(0, Experience_Paths.size()):
			get_node(Experience_Paths[i]).call("SetEnable", (i == EricComputerUI.CurrentExperience));
		
		_SetBarrierDisabled(false);  #Turn on the barriers while the experience is loading
		IsLoading = true;
		InitLoad = false;
		SoundFXPlayer.PlaySound("LoadMatrix.mp3", get_tree(), global_position, 5.0, 20.0);
	
	if IsLoading == true and last_loading == false:
		_SetBarrierDisabled(true);
	if UnloadNow == true:
		UnloadNow = false;
		for i in range(0, Experience_Paths.size()):
			get_node(Experience_Paths[i]).call("SetEnable", false);
		
	last_loading = IsLoading;
	pass;
