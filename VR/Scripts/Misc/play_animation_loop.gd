class_name PlayAnimationLoop extends Node3D

@export var Min_Speed = 1.0;
@export var Max_Speed = 1.0;
@export var animation_path : NodePath;
@export var animation_name = "SwayAnimationLibrary/SwayAnimation"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node(animation_path).play(animation_name, -1, randf_range(Min_Speed, Max_Speed));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
