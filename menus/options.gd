class_name GameOptions
extends CanvasLayer

static var low_res := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$%MasterSlider.value = AudioServer.get_bus_volume_linear(0) * 50.0
	$%SFXSlide.value = AudioServer.get_bus_volume_linear(1) * 50.0
	$%BGMSlide.value = AudioServer.get_bus_volume_linear(2) * 50.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$%MasterVol.text = str(roundi($%MasterSlider.value)) + "%"
	$%SFXVol.text = str(roundi($%SFXSlide.value)) + "%"
	$%BGMVol.text = str(roundi($%BGMSlide.value)) + "%"

func _on_master_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_linear(0, value / 50.0)


func _on_back_pressed() -> void:
	if get_parent().name != "Interface":
		GGT.change_scene("res://menus/menu.tscn")
	else:
		GameplayInterface.no_input = false
		GameplayInterface.pause = false
		get_parent().remove_child(self)
		queue_free()

func _on_sfx_slide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value / 50.0)
	AudioServer.set_bus_volume_linear(3, value / 50.0)

func _on_bgm_slide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value / 50.0)


func _on_check_box_toggled(toggled_on: bool) -> void:
	low_res = toggled_on
	if GameplayInterface.global:
		(GameplayInterface.global.get_node("SubViewportContainer") as SubViewportContainer).stretch_shrink = 3 if low_res else 1
