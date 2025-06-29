class_name MainMenu
extends Control

@onready var btn_play = $MarginContainer/Control/VBoxContainer/PlayButton
@onready var btn_exit = $MarginContainer/Control/VBoxContainer/ExitButton

static var no_kagumokou := false
static var calm_mode := false

#static var just_finished := false

func _ready():
	GameConfig.init()

	var scene_params = GGT.get_current_scene_data().params

	AudioServer.set_bus_volume_linear(0, GameConfig.file.get_value("options", "vol_master", 50.0) / 50.0)
	AudioServer.set_bus_volume_linear(1, GameConfig.file.get_value("options", "vol_sfx", 50.0) / 50.0)
	AudioServer.set_bus_volume_linear(3, GameConfig.file.get_value("options", "vol_sfx", 50.0) / 50.0)
	AudioServer.set_bus_volume_linear(2, GameConfig.file.get_value("options", "vol_bgm", 50.0) / 50.0)

	if GameConfig.file.get_value("game", "completed", false) and not GlobalAudioPlayer.playing:
		GlobalAudioPlayer.stream = GlobalAudio.BGM_TITLE
		GlobalAudioPlayer.play()
		#$AudioStreamPlayer2D.play()
	else:
		#$AudioStreamPlayer2D.stream = GlobalAudio.BGM_ENDING
		GlobalAudioPlayer.finished.connect(_play_title_theme_after_ending_theme)
		#$AudioStreamPlayer2D.play()

	# needed for gamepads to work
	btn_play.grab_focus()
	if OS.has_feature('web'):
		btn_exit.queue_free() # exit button dosn't make sense on HTML5

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		GameConfig.save()

func _play_title_theme_after_ending_theme() -> void:
	GlobalAudioPlayer.finished.disconnect(_play_title_theme_after_ending_theme)
	GlobalAudioPlayer.stream = GlobalAudio.BGM_TITLE
	GlobalAudioPlayer.play()

func _on_PlayButton_pressed() -> void:
	GlobalAudioPlayer.stop()

	var params = {
		"show_progress_bar": true
	}
	GGT.change_scene("res://gameplay/interface.tscn", params)

func _on_ExitButton_pressed() -> void:
	GameConfig.save()

	# gently shutdown the game
	var transitions = get_node_or_null("/root/GGT_Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		await transitions.anim.animation_finished
		await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_options_button_pressed() -> void:
	GGT.change_scene("res://menus/options.tscn")


func _on_credits_button_pressed() -> void:
	GGT.change_scene("res://menus/credits.tscn")


func _on_check_button_toggled(toggled_on:bool) -> void:
	no_kagumokou = toggled_on


func _on_check_button_2_toggled(toggled_on:bool) -> void:
	calm_mode = toggled_on
