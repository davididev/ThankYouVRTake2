class_name BreakoutBall extends RigidBody3D

const MOVE_FORCE = 30.0;
var ForwardVec : Vector3;

func _physics_process(delta: float) -> void:
	ForwardVec.y = 0.0;
	add_constant_force(MOVE_FORCE * ForwardVec);
	if global_position.z > 1.5:
		queue_free();


func _on_body_entered(body: Node) -> void:
	var n = body as Node3D;
	if n.has_signal("Hit"):
		n.emit_signal("Hit");
	ForwardVec = (n.global_position - global_position).normalized();
	
