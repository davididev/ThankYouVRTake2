@tool
extends MeshInstance3D

@export var decal_material_path: Resource  # Path to the decal material
@export var start_time: float = 0.0  # Start time for the decal animation
@export var layer_mask: int = 1  # Layer mask to filter the shader effect

func _ready() -> void:
	if decal_material_path == null:
		return

	var material = decal_material_path as ShaderMaterial
	if material:
		material.set_shader_parameter("layer_mask", layer_mask)
		material.set_shader_parameter("object_layer", get_layer_mask())  # Pass the object's layer mask
