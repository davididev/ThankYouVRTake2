@tool
extends Node3D

@export var decal_material_path: Resource  # Path to the decal material
@export var start_time: float = 0.0  # Start time for the decal animation

func _ready() -> void:
	if decal_material_path == null:
		return

	var material = decal_material_path as ShaderMaterial
	if material:
		material.set_shader_parameter("start_time", start_time)
