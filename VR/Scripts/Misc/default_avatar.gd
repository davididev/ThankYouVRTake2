class_name DVD_Avatar extends Node3D

@export var Player_Body_Path : NodePath;
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
var local_leg_length : float;  #Distance from hip to foot

var delta_movement : Vector3;  #Amount we moved on this framestep
var velocity_movement : Vector3;  #Amount per second on this frame

var layer_mask_foot = 0;

var BONE_LEFT_HAND : int;
var BONE_RIGHT_HAND : int;
var BONE_LEFT_HIP : int;
var BONE_RIGHT_HIP : int;
var BONE_LEFT_FOOT : int;
var BONE_RIGHT_FOOT : int;
var BONE_LEFT_EYE : int;
var BONE_RIGHT_EYE : int;
var BONE_NECK : int;

func _enter_tree() -> void:
	lastPos = get_node(Camera_Path).global_position;
	lastPos.y = global_position.y;
	last_animation = "";
	var skel = get_node(Skeleton_Path) as Skeleton3D;
	BONE_LEFT_HIP = skel.find_bone("DEF-thigh.L");
	BONE_RIGHT_HIP = skel.find_bone("DEF-thigh.R");
	BONE_LEFT_FOOT = skel.find_bone("DEF-foot.L");
	BONE_RIGHT_FOOT = skel.find_bone("DEF-foot.R");
	BONE_LEFT_EYE = skel.find_bone("DEF-eye.L");
	BONE_RIGHT_EYE = skel.find_bone("DEF-eye.R");
	BONE_NECK = skel.find_bone("DEF-neck");
	 #temp var to calculate one of the feet before animation starts
	var local_pos_left_hip = skel.get_bone_pose_position(BONE_LEFT_HIP);
	var local_pos_left_foot = skel.get_bone_pose_position(BONE_LEFT_FOOT);
	local_leg_length = abs(local_pos_left_foot.y - local_pos_left_hip.y);
	layer_mask_foot = pow(2, 1-1) + pow(2, 2-1);  #Set to static world and dynamic world
	
	#Calculate initial eye midpoint
	#eye_midPoint *= -1.0;
var lastPos : Vector3;
var walking_time = -1.0;
#Calculate delta movement and velocity (also move avatar)
func _calculate_delta_change(delta):  
	#Move to the midpoint between the two eyes
	var skel = get_node(Skeleton_Path) as Skeleton3D;
	#var rel_movement = global_eye_real_pos - skel.global_position;  #Relative from skeleton base to skeleton eyes
	#global_position = get_node(Camera_Path).global_position + rel_movement;
	#delta_movement = (target_pos - global_position);
	velocity_movement = get_node(Camera_Path).global_position - lastPos;
	velocity_movement.y = 0.0;
	velocity_movement = velocity_movement / delta;
	if velocity_movement.length() > 0.5:
		walking_time = 0.1;
	#Set position (relative between Camera point / eyepoint
	
	var temp_left_eye = skel.get_bone_pose_position(BONE_LEFT_EYE);
	var temp_right_eye = skel.get_bone_pose_position(BONE_RIGHT_EYE);
	
	eye_midPoint = (temp_left_eye + temp_right_eye) / 2.0;
	#eye_midPoint.z *= 0.8;
	
	
	
	
	#Look at point between two hands after moving
	var global_midpoint = (get_node(LeftHand_Path).global_position + get_node(RightHand_Path).global_position) / 2.0;
	var localCam = get_node(Camera_Path).to_local(global_midpoint);
	localCam.z = clampf(localCam.z, 1.0, 100000.0);
	var correctedCameraPoint = get_node(Camera_Path).to_global(localCam);
	get_node(Look_At_Path).global_position = global_position;
	get_node(Look_At_Path).look_at(correctedCameraPoint, Vector3.UP, true);
	var skel_rot = get_node(Look_At_Path).rotation;
	skel_rot.x = 0.0;
	skel_rot.z = 0.0;
	rotation = skel_rot;

	#global_position = global_position + delta_movement;	
	var pb = get_node(Player_Body_Path) as XRToolsPlayerBody;
	
	var newPos = pb.origin_node.global_position;
	#newPos.y -= pb._player_height_override_current * 2.0;
	global_position = newPos;
	get_child(0).position = eye_midPoint;  #Use the eye local position to set a child to position
	skel.set_bone_pose_rotation(BONE_NECK, get_node(Camera_Path).get_quaternion())
	
var last_animation = "";

func _animation(delta : float):
	var anim_tree = get_node(Animation_Tree_Path) as AnimationTree;
	var state_machine = anim_tree.get("parameters/playback")
	if last_animation != "Idle" and state_machine != null:
		state_machine.travel("Idle");
		last_animation = "Idle"

func _process(delta: float) -> void:
	get_node(Left_Hand_IK_Path).start();
	get_node(Right_Hand_IK_Path).start();
	_calculate_delta_change(delta);
	_animation(delta);
