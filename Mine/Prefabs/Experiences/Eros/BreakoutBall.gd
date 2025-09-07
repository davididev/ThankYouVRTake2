class_name BreakoutBall extends RigidBody3D

const MOVE_FORCE = 25.0;
var ForwardVec : Vector3;
const BOUNCE_DELAY = 0.05;
var bounce_timer = 0.0;
@onready var _shape := $"ShapeCast3D"

func _physics_process(delta: float) -> void:
	ForwardVec.y = 0.0;
	apply_force(MOVE_FORCE * ForwardVec);
	if global_position.z > 1.5:
		queue_free();

	var space_state = get_world_3d().direct_space_state;
	#var origin = global_position;
	#var target = origin + (ForwardVec * 1.75);
	_shape.target_position = (ForwardVec * 2.0);
	
	#var query = PhysicsRayQueryParameters3D.create(origin, target, self.collision_mask);
	#var result = space_state.intersect_ray(query);
	
	#if result.is_empty() == false:
		#if result.normal.y < 0.5:  #Don't get from floor
	if bounce_timer > 0.0:
		bounce_timer -= delta;
	if bounce_timer <= 0.0:
		if _shape.is_colliding():
			bounce_timer = BOUNCE_DELAY;
			for id in range(0, _shape.get_collision_count()):
				var normal = _shape.get_collision_normal(id);
			
				if normal.y < 0.5 and normal.y > -0.5:  #Don't do it if it's floor/ceiling
					var newFwd = ForwardVec.reflect(normal).normalized();
					newFwd.y = 0.0;
					ForwardVec = newFwd;
					
					var pitch = randf_range(0.8, 1.2);
					SoundFXPlayer.PlaySound("digital/phaseJump1.ogg", get_tree(), global_position, 10.0, 4.0, pitch);
					var col = _shape.get_collider(id);
					if col.has_signal("Hit"):
						col.emit_signal("Hit");
			
				
			#var newFwd = ForwardVec.bounce(result.normal);
			#newFwd.y = 0.0;
			#ForwardVec = newFwd;
			#if result.collider != null:
			#	DebugContent.DebugText = result.collider.name;
			#	if result.collider.has_signal("Hit"):
			#		result.collider.emit_signal("Hit");

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
	
