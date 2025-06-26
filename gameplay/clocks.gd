#@tool
class_name Clocks
extends Node3D

static var one := true

# static var last_big: float = 0
# static var last_sm: float = 0
static var last_sec: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_volume(v: float) -> void:
	for cl in get_children():
		(cl.get_node("SpatialAudioPlayer3D") as SpatialAudioPlayer3D).volume_db = v

func _play_sound(cl: Node3D) -> void:
	if one:
		#print("tick")
		GlobalAudio.play3d_p(cl.get_node("SpatialAudioPlayer3D"), GlobalAudio.SFX_CLOCK1)
		one = false
	else:
		#print("tock")
		GlobalAudio.play3d_p(cl.get_node("SpatialAudioPlayer3D"), GlobalAudio.SFX_CLOCK2)
		one = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time := Time.get_time_dict_from_system()
	var hour = time["hour"]
	var minute = time["minute"]
	var second = time["second"]

	var big: float = -(360 / 60.0) * (minute + second / 60.0)
	var sm: float = -(360 / 12.0) * (hour % 12 + minute / 60.0)
	var sec: float = -(360 / 60.0) * second

	for cl in get_children():
		var cbig := cl.get_node("Pivot0") as Node3D
		var csm := cl.get_node("Pivot1") as Node3D
		var csec := cl.get_node("Pivot2") as Node3D

		if sec != last_sec:
			_play_sound(cl)

		cbig.rotation_degrees.y = big
		csm.rotation_degrees.y = sm
		csec.rotation_degrees.y = sec
	
	last_sec = sec
