@tool
class_name EpilogueEnvironment
extends Node3D

@export_tool_button("Lighten sky", "Callable") var ls_action = lighten_sky

@onready var d := $DirectionalLight3D as DirectionalLight3D
@onready var s := ($WorldEnvironment.environment as Environment).sky.sky_material as ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	d.light_energy = 0.3
	s.set_shader_parameter("sky_energy", 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func lighten_sky() -> void:
	d.light_energy = 0.3
	s.set_shader_parameter("sky_energy", 0.1)

	while d.light_energy < 1.0 or s.get_shader_parameter("sky_energy") < 0.9:
		d.light_energy = clamp(d.light_energy + 0.02, 0, 1)
		s.set_shader_parameter("sky_energy", clamp(s.get_shader_parameter("sky_energy") + 0.02, 0.1, 0.9))
		await get_tree().create_timer(0.05).timeout
