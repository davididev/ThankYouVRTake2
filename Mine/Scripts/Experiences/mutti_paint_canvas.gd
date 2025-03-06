class_name MuttiPaintCanvas extends RigidBody3D

static var CurrentColor : Color;
var player_body : Node3D = null;
@export var path_to_renderer : NodePath;
var currentTexture : Image;
var lastPoint : Vector3;
const MIN_DISTANCE_CHANGE = 0.2 / 3.5;
var mesh;
var meshtool : MeshDataTool;

var player_hit_layer_mask : int;

var brush_tex = Image.load_from_file("res://Mine/Models/Mutti/Canvas/PaintBrush.png");

func _ready() -> void:
	player_hit_layer_mask = pow(2, 2-1);  #Set the layer mask to layer 2.
	lastPoint = Vector3.ZERO;
	
	meshtool = MeshDataTool.new();
	meshtool.create_from_surface(get_node(path_to_renderer).mesh, 0);
	CurrentColor = Color.BLACK;
	currentTexture = Image.load_from_file("res://Mine/Models/Mutti/Canvas/StartingWhiteTexture.png").duplicate();
	#var datam = currentTexture.get_data();
	player_body = null;


func paint_closest_point(pt : Vector3):
	if pt.distance_to(lastPoint) < MIN_DISTANCE_CHANGE:  #We've barely moved- don't paint a new point
		return;
	lastPoint = pt;
	print("Current point is ", lastPoint);
	
	var maxVertex = meshtool.get_vertex_count();
	var endingPoint = -1;
	for vid in range(0, maxVertex):
		var vpos = get_node(path_to_renderer).to_global(meshtool.get_vertex(vid));  #Get position of current vertex
		if vpos.distance_to(pt) <= MIN_DISTANCE_CHANGE:
			endingPoint = vid;
			break;
	
	if endingPoint != -1:
		var uvPoint : Vector2 = meshtool.get_vertex_uv(endingPoint);
		print("Current UV is ", uvPoint);
		
		uvPoint.x *= currentTexture.get_width();
		uvPoint.y *= currentTexture.get_height();
		
		var ux = floori(uvPoint.x);
		var uy = floori(uvPoint.y);
		print("Real coords: ", ux, ",", uy);
		PaintCircle(ux, uy)
		
		var sm = get_node(path_to_renderer).get_surface_override_material(0) as ShaderMaterial;
		sm.set_shader_parameter("Texture2DParameter", ImageTexture.create_from_image(currentTexture));
		get_node(path_to_renderer).set_surface_override_material(0, sm);
	pass;

func PaintCircle(ux : int, uy : int):
	var width = brush_tex.get_width();
	var height = brush_tex.get_height();
	for bx in range(0, width):
		for by in range(0, height):
			var c = brush_tex.get_pixel(bx, by) * CurrentColor; 
			if(c.a > 0.75):  #Don't change transparent parts
				var offsetX = (ux + bx) - (width / 2);
				var offsetY = (uy + by) - (height / 2);
				offsetX = clampi(offsetX, 0, currentTexture.get_width() - 1);
				offsetY = clampi(offsetY, 0, currentTexture.get_height() - 1);
				currentTexture.set_pixel(offsetX, offsetY, c);



func _physics_process(delta: float) -> void:
	if player_body != null:  #There is a player on the canvas, start drawing
		#paint_closest_point(player_body.global_position);
		var space_state = get_world_3d().direct_space_state;
		var origin = player_body.global_position;
		var end = origin + Vector3(0.0, -2.5, 0.0);
		var query = PhysicsRayQueryParameters3D.create(origin, end, player_hit_layer_mask);
		query.collide_with_bodies = true;
		
		var result = space_state.intersect_ray(query);
		if result.is_empty() == false:
			paint_closest_point(result.position);
		
		pass;


func _on_body_entered(body: Node) -> void:
	print("Body collided");
	if body.is_in_group("player_body"):
		player_body = body as Node3D;


func _on_body_exited(body: Node) -> void:
	print("Body exited");
	if body.is_in_group("player_body"):  #Remove from trace
		player_body = null;
		lastPoint = Vector3.ZERO;
