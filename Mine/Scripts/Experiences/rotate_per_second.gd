class_name RotatePerSecond extends MeshInstance3D

@export var RotateAmount : Vector3;
@export var Multiplier = 0.0;
const RAD_TO_DEG = 0.0174533;

func _process(delta: float) -> void:
	var thisStepRot = RotateAmount * Multiplier * delta;
	rotate_x(thisStepRot.x * RAD_TO_DEG);
	rotate_y(thisStepRot.y * RAD_TO_DEG);
	rotate_z(thisStepRot.z * RAD_TO_DEG);
