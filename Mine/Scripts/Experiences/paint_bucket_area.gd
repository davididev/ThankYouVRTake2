class_name PaintBucketArea extends Area3D

@export var paint_path : NodePath;
@export var ui_overlay_image : Texture2D;
@export var paint_color : Color;

func _ready() -> void:
	var ss = get_node(paint_path).get_surface_override_material(0) as StandardMaterial3D;
	ss.albedo_color = paint_color;
	get_node(paint_path).set_surface_override_material(0, ss);


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		MuttiPaintCanvas.CurrentColor = paint_color;
		OverlayUI.SetOverlayImage(ui_overlay_image as Texture2D, paint_color, 0.5);
