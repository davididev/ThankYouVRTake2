class_name MuttiPaintCanvas extends RigidBody3D

static var CurrentColor : Color;
var player_body : Node3D = null;
@export var path_to_renderer : NodePath;
var currentTexture : Texture2D;

func _init() -> void:
	CurrentColor = Color.BLACK;
	currentTexture = load("res://Mine/Models/Mutti/Canvas/StartingWhiteTexture.png");
	#var datam = currentTexture.get_data();
	player_body = null;

func _physics_process(delta: float) -> void:
	pass;
	if player_body != null:  #There is a player on the canvas, start drawing
		pass;


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player_body"):
		player_body = body as Node3D;


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player_body"):  #Remove from trace
		player_body = null;
