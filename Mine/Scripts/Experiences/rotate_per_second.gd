class_name RotatePerSecond extends MeshInstance3D

@export var RotateAmount : Vector3;
@export var Multiplier = 0.0;

func _process(delta: float) -> void:
	var thisStepRot = RotateAmount * Multiplier * delta;
	rotate_x(thisStepRot.x);
	rotate_y(thisStepRot.y);
	rotate_z(thisStepRot.z);
