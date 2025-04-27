class_name DVD_Avatar extends Node3D

@export var Camera_Path : NodePath;
@export var Animation_Tree_Path : NodePath;
@export var LeftHand_Path : NodePath;  #These should be the targets
@export var RightHand_Path : NodePath; #These should be the targets
@export var Left_Foot_Target_Path : NodePath;
@export var Right_Foot_Target_Path : NodePath;
@export var Skeleton_Path : NodePath;
@export var Left_Hand_IK_Path : NodePath;
@export var Right_Hand_IK_Path : NodePath;
@export var Left_Foot_IK_Path : NodePath;
@export var Right_Foot_IK_Path : NodePath;
@export var Look_At_Path : NodePath;

var eye_midPoint
var local_pos_left_hip : Vector3;
var local_pos_right_hip : Vector3;
var local_distance_from_hip_to_foot : float;

var delta_movement : Vector3;  #Amount we moved on this framestep
var velocity_movement : Vector3;  #Amount per second on this frame

var layer_mask_foot = 0;

func _enter_tree() -> void:
	last_animation = "";
	var skel = get_node(Skeleton_Path) as Skeleton3D;
	local_pos_left_hip = skel.get_bone_pose_position(skel.find_bone("DEF-thigh.L"));
	
	local_pos_right_hip = skel.get_bone_pose_position(skel.find_bone("DEF-thigh.R"));
	#temp var to calculate one of the feet before animation starts
	var local_pos_left_foot = skel.get_bone_pose_position(skel.find_bone("DEF-foot.L"));
	local_distance_from_hip_to_foot = abs(local_pos_left_foot.y - local_pos_left_hip.y);
	layer_mask_foot = pow(2, 1-1) + pow(2, 2-1);  #Set to static world and dynamic world
	
	#Calculate initial eye midpoint
	var temp_left_eye = skel.get_bone_pose_position(skel.find_bone("DEF-eye.L"));
	var temp_right_eye = skel.get_bone_pose_position(skel.find_bone("DEF-eye.R"));
	eye_midPoint = (temp_left_eye + temp_right_eye) / 2.0;
	#eye_midPoint *= -1.0;

#Calculate delta movement and velocity (also move avatar)
func _calculate_delta_change(delta):  
	#Move to the midpoint between the two eyes
	var skel = get_node(Skeleton_Path) as Skeleton3D;
	#var rel_movement = global_eye_real_pos - skel.global_position;  #Relative from skeleton base to skeleton eyes
	#global_position = get_node(Camera_Path).global_position + rel_movement;
	#delta_movement = (target_pos - global_position);
	
	#Set position (relative between Camera point / eyepoint
	var eyePoint = skel.to_global(eye_midPoint)
	delta_movement = get_node(Camera_Path).global_position - eyePoint;
	
	#Look at point between two hands after moving
	var handsMidPoint = get_node(Camera_Path).to_local((get_node(LeftHand_Path).global_position + get_node(RightHand_Path).global_position) / 2.0);
	handsMidPoint.z = clamp(handsMidPoint.z, 1.0, 1000.0);
	handsMidPoint = get_node(Camera_Path).to_global(handsMidPoint);
	get_node(Look_At_Path).look_at(handsMidPoint, Vector3(0, 1, 0), true);
	var skel_rot = global_rotation;
	skel_rot.y = get_node(Look_At_Path).global_rotation.y;
	global_rotation = skel_rot;

	global_position = global_position + delta_movement;	
	velocity_movement = delta_movement / delta;
	
var last_animation = "";

func _animation(delta : float):
	var anim_tree = get_node(Animation_Tree_Path) as AnimationTree;
	var state_machine = anim_tree.get("parameters/playback")
	if last_animation != "Idle" and state_machine != null:
		state_machine.travel("Idle");
		last_animation = "Idle"

func _process(delta: float) -> void:
	_calculate_delta_change(delta);
	_animation(delta);
