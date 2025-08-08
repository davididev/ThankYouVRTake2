class_name AvatarFootIKAnimator extends Node3D

@onready var markerL  = $"Left Root/MarkerL";
@onready var markerR = $"Right Root/MarkerR";
@onready var anim = $"AnimationPlayer/AnimationTree";

#For the animation tree
@export var MoveTimer = 0.0;  #Time elapsed since you last moved
@export var MoveDirection : Vector2;
@export var IsGrounded = true;
@export var IsInAirTime = 0.0;

func GetFootExtentsL():
	return markerL.position;

func GetFootExtentsR():
	return markerR.position;

func _process(delta: float) -> void:
	pass;
	if IsGrounded:
		IsInAirTime = 0.0;
	else:
		IsInAirTime += delta;
	#DebugContent.DebugText = str("WK: ", MoveTimer);
