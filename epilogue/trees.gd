@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_children():
		if x is Node3D:
			x.scale += Vector3(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
			x.rotation_degrees = Vector3(0, randf_range(-180, 180), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
