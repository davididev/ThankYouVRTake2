class_name ErosProgram extends Node3D

@export var NodesToReset : Array[NodePath];
@export var GridMaps : Array[NodePath];
@export var CollidersToReset : Array[NodePath];
const LOAD_MOVE_PER_SECOND = 40.0
signal OnEnableNode();

func SetEnable(b: bool):
	global_position = Vector3(0.0, -100.0, 0.0);  #Put it out of the way whether we turn it off or on
	visible = b;
	if b == true:
		for i in range(0, NodesToReset.size()):
			get_node(NodesToReset[i]).emit_signal("OnEnableNode");
	
	var enabledMask = pow(2, 1-1);
	var disabledMask = 0;
	for i in range(0, GridMaps.size()):
		var gm = get_node(GridMaps[i]) as GridMap;
		if b == true:
			gm.collision_layer = enabledMask;
		else:
			gm.collision_layer = disabledMask;

	for i in range(0, CollidersToReset.size()):
		get_node(CollidersToReset[i]).set_deferred("disabled", !b);

func _process(delta: float) -> void:
	if ErosComputer.IsLoading == true:
		var vec = global_position;
		vec.y = move_toward(vec.y, 0.0, LOAD_MOVE_PER_SECOND * delta)
		if is_equal_approx(vec.y, 0.0):
			ErosComputer.IsLoading = false;
		global_position = vec;
