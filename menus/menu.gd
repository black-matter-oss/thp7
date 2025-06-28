class_name MainMenu
extends Control

@onready var btn_play = $MarginContainer/Control/VBoxContainer/PlayButton
@onready var btn_exit = $MarginContainer/Control/VBoxContainer/ExitButton

static var no_kagumokou := false
static var calm_mode := false

func _ready():
	# needed for gamepads to work
	btn_play.grab_focus()
	if OS.has_feature('web'):
		btn_exit.queue_free() # exit button dosn't make sense on HTML5


func _on_PlayButton_pressed() -> void:
	var params = {
		"show_progress_bar": true
	}
	GGT.change_scene("res://gameplay/interface.tscn", params)


func _on_ExitButton_pressed() -> void:
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
