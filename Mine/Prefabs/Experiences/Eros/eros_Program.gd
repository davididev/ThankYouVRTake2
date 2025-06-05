class_name ErosProgram extends Node3D

@export var NodesToReset : Array[NodePath];
signal OnEnableNode();

func SetEnable(b: bool):
	global_position = Vector3(0.0, -100.0, 0.0);  #Put it out of the way whether we turn it off or on
	visible = b;
	if b == true:
		for i in range(0, NodesToReset.size()):
			get_node(NodesToReset[i]).emit_signal("OnEnableNode");
	
