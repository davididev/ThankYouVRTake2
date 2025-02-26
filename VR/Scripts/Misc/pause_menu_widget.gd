class_name PauseMenuWidget extends Node3D
var _controller : XRController3D
@export var left_hand_path : NodePath;

const SCALE_CLOSED = 0.01;
const SCALE_OPEN = 0.5;
var currentScale = SCALE_CLOSED;
var targetScale = SCALE_CLOSED;

var lastMenuPressed = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lastMenuPressed = false;
	_controller = XRTools.find_xr_ancestor(get_node(left_hand_path), "*", "XRController3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	currentScale = move_toward(currentScale, targetScale, 5.0 * delta);
	scale = Vector3.ONE * currentScale;
	
	var currentlyInvisible = is_equal_approx(currentScale, SCALE_CLOSED);
	visible = !currentlyInvisible;
	
	var menu : float = _controller.get_float("menu_button");
	if is_zero_approx(menu):
		lastMenuPressed = false;
	else:
		if lastMenuPressed == false:
			lastMenuPressed = true;
			if is_equal_approx(targetScale, SCALE_OPEN):
				targetScale = SCALE_CLOSED;
			else:
				targetScale = SCALE_OPEN;
			
	
	if visible == true:  #Move it over left hand and such
		look_at(PosVelCalc.HeadPos, Vector3.UP, true);
		global_position = PosVelCalc.LeftHandPos + Vector3(0.0, 0.15, 0.0);
		
