class_name GameOptions
extends CanvasLayer

static var low_res := false
static var read_user_data := false

static var msaa := 1
static var fxaa := true
static var taa := false

static var res_scale := 1.0
static var scale_method := 0

static var shadows := 2
static var lights := true
static var reflections := false

static func set_viewport_options(viewport: SubViewport) -> void:
	#(viewport.get_parent() as SubViewportContainer).stretch_shrink = 2 if low_res else 1

	match msaa:
		0:
			viewport.msaa_3d = Viewport.MSAA_DISABLED
		1:
			viewport.msaa_3d = Viewport.MSAA_2X
		2:
			viewport.msaa_3d = Viewport.MSAA_4X
		3:
			viewport.msaa_3d = Viewport.MSAA_8X
		_:
			viewport.msaa_3d = Viewport.MSAA_DISABLED
	
	viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if fxaa else Viewport.SCREEN_SPACE_AA_DISABLED
	viewport.use_taa = taa
	
	viewport.scaling_3d_scale = res_scale
	viewport.scaling_3d_mode = scale_method as Viewport.Scaling3DMode
	
	# print("Low-res mode: " + str(low_res))
	# print("MSAA: " + str(viewport.msaa_3d))
	# print("FXAA: " + str(fxaa))
	# print("TAA: " + str(taa))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().name != "Interface":
		$ColorRect.visible = true

	# if read_user_data:
	# 	$%MasterSlider.value = AudioServer.get_bus_volume_linear(0) * 50.0
	# 	$%SFXSlide.value = AudioServer.get_bus_volume_linear(1) * 50.0
	# 	$%BGMSlide.value = AudioServer.get_bus_volume_linear(2) * 50.0
	# else:
	$%MasterSlider.value = GameConfig.file.get_value("options", "vol_master", 50.0)
	$%SFXSlide.value = GameConfig.file.get_value("options", "vol_sfx", 50.0)
	$%BGMSlide.value = GameConfig.file.get_value("options", "vol_bgm", 50.0)

	low_res = GameConfig.file.get_value("options", "gfx_lowres", low_res)
	msaa = GameConfig.file.get_value("options", "gfx_msaa", msaa)
	fxaa = GameConfig.file.get_value("options", "gfx_fxaa", fxaa)
	taa = GameConfig.file.get_value("options", "gfx_taa", taa)
	shadows = GameConfig.file.get_value("options", "gfx_shadows", shadows)
	lights = GameConfig.file.get_value("options", "gfx_lights", lights)
	reflections = GameConfig.file.get_value("options", "gfx_ssr", reflections)
	res_scale = GameConfig.file.get_value("options", "gfx_res_scale", res_scale)
	scale_method = GameConfig.file.get_value("options", "gfx_scale_method", scale_method)

	$%PixelArtCheckbox.button_pressed = low_res
	$%MSAAOption.selected = msaa
	$%FXAACheckBox.button_pressed = fxaa
	$%TAACheckBox.button_pressed = taa

	$%ResScaleSlider.value = res_scale * 100
	$%SMOptionButton.selected = scale_method

	$%ShadowOptions.selected = shadows
	$%LightingQualityOption.selected = lights
	$%SSRCheckBox.button_pressed = reflections

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$%MasterVol.text = str(roundi($%MasterSlider.value)) + "%"
	$%SFXVol.text = str(roundi($%SFXSlide.value)) + "%"
	$%BGMVol.text = str(roundi($%BGMSlide.value)) + "%"
	$%ResScaleLabel.text = str(roundi(res_scale * 100)) + "%"

func _on_master_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_linear(0, value / 50.0)
	GameConfig.file.set_value("options", "vol_master", value)

func _on_back_pressed() -> void:
	GameConfig.save()

	if get_parent().name == "Interface":
		GameplayInterface.no_input = false
		GameplayInterface.pause = false

	get_parent().remove_child(self)
	queue_free()

func _on_sfx_slide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value / 50.0)
	AudioServer.set_bus_volume_linear(3, value / 50.0)
	GameConfig.file.set_value("options", "vol_sfx", value)

func _on_bgm_slide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value / 50.0)
	GameConfig.file.set_value("options", "vol_bgm", value)

func _on_check_box_toggled(toggled_on: bool) -> void:
	low_res = toggled_on
	GameConfig.file.set_value("options", "gfx_lowres", toggled_on)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)

func _on_option_button_item_selected(index:int) -> void:
	msaa = index
	GameConfig.file.set_value("options", "gfx_msaa", index)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)

func _on_fxaa_check_box_toggled(toggled_on:bool) -> void:
	fxaa = toggled_on
	GameConfig.file.set_value("options", "gfx_fxaa", toggled_on)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)

func _on_taa_check_box_toggled(toggled_on:bool) -> void:
	taa = toggled_on
	GameConfig.file.set_value("options", "gfx_taa", toggled_on)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)

func _on_shadow_options_item_selected(index:int) -> void:
	shadows = index
	GameConfig.file.set_value("options", "gfx_shadows", index)
	if GameWorld.global:
		GameWorld.global.graphic_options_change.emit()

func _on_lighting_quality_option_item_selected(index: int) -> void:
	lights = index
	GameConfig.file.set_value("options", "gfx_lights", index == 1)
	if GameWorld.global:
		GameWorld.global.graphic_options_change.emit()


func _on_ssr_check_box_toggled(toggled_on: bool) -> void:
	reflections = toggled_on
	GameConfig.file.set_value("options", "gfx_ssr", toggled_on)
	if GameWorld.global:
		GameWorld.global.graphic_options_change.emit()


func _on_sm_option_button_item_selected(index: int) -> void:
	scale_method = index
	GameConfig.file.set_value("options", "gfx_scale_method", index)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)


func _on_res_scale_slider_value_changed(value: float) -> void:
	res_scale = value / 100.0
	GameConfig.file.set_value("options", "gfx_res_scale", res_scale)
	if GameplayInterface.global:
		set_viewport_options(GameplayInterface.global.get_node("SubViewportContainer/SubViewport") as SubViewport)

func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
