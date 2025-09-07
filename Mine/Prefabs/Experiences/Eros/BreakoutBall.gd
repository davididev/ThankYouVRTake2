class_name BreakoutBall extends RigidBody3D

const MOVE_FORCE = 15.0;
var ForwardVec : Vector3;

func _physics_process(delta: float) -> void:
	ForwardVec.y = 0.0;
	apply_force(MOVE_FORCE * ForwardVec);
	if global_position.z > 1.5:
		queue_free();

	var space_state = get_world_3d().direct_space_state;
	var origin = global_position + Vector3(0.0, -0.9, 0.0);
	var target = origin + (ForwardVec * 1.75);
	var query = PhysicsRayQueryParameters3D.create(origin, target, self.collision_mask);
	var result = space_state.intersect_ray(query);
	if result.is_empty() == false:
		if result.normal.y < 0.5:  #Don't get from floor
			var pitch = randf_range(0.8, 1.2);
			SoundFXPlayer.PlaySound("digital/phaseJump1.ogg", get_tree(), global_position, 10.0, 4.0, pitch);
			var newFwd = ForwardVec.bounce(result.normal);
			newFwd.y = 0.0;
			ForwardVec = newFwd;
			if result.collider != null:
				DebugContent.DebugText = result.collider.name;
				if result.collider.has_signal("Hit"):
					result.collider.emit_signal("Hit");

#func _on_body_entered(body: Node) -> void:
	#var n = body as Node3D;
	#DebugContent.DebugText = n.name;
	#if n.name == "InvisibleBounds":
		#return;
	#if n.name == "Floors":
		#return;
	#if n.has_signal("Hit"):
		#n.emit_signal("Hit");
	#ForwardVec.x *= -1.0;
	#ForwardVec.z *= -1.0;
	
