@tool
extends OmniLight3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light_energy += randf_range(-1, 1) * delta * 2
	light_energy = clamp(light_energy, 0.3, 0.9)

	# omni_range += randf_range(-2, 2) * delta
	# omni_range = clamp(omni_range, 0.5, 1.0)
