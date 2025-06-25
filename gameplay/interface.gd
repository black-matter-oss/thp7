@tool
class_name GameplayInterface
extends Control

enum GameState {
	WAITING,
	CONVERSATION,
	IDLE
}

#const idle_interface := preload("res://gameplay/idle.tscn")
const wait_interface := preload("res://gameplay/wait.tscn")
const call_menu := preload("res://gameplay/call_menu.tscn")
const quest_menu := preload("res://gameplay/quest_menu.tscn")

@onready var day_tracker := $DayTracker
@onready var sub := $SubInterface
var state := GameState.WAITING

var day_thread: Thread

var cm: Node
var qm: Node

static var global: GameplayInterface

@onready var camera: WorldCamera = $SubViewportContainer/SubViewport/World/Player/satori/Camera3D
var do_raycast := true

func new_day() -> void:
	print("New day!")
	$%NewDayBtn.visible = false
	#$SubViewportContainer/SubViewport/World/AnimationPlayer.play("day_pass")
	$SubViewportContainer/SubViewport/World/Lights.visible = false
	day_thread.wait_to_finish()
	day_tracker.start_new_day()
	day_thread = Thread.new()
	day_thread.start(day_tracker.begin_loop)

func show_day_count(d: int) -> void:
	#$DayPass.modulate.a = 0
	$DayPass.visible = true
	$%DayInfo.text = "Day " + str(d)
	$%CharaInfo.text = "Characters to visit today:"

	for c in day_tracker.current_day.characters_to_visit:
		$%CharaInfo.text += "\n" + c.name

	while $DayPass.modulate.a < 1:
		$DayPass.modulate.a += 0.01
		await get_tree().create_timer(0.01).timeout
	
	$DayPass.modulate.a = 1
	await get_tree().create_timer(3).timeout

	while $DayPass.modulate.a > 0:
		$DayPass.modulate.a -= 0.01
		await get_tree().create_timer(0.01).timeout
	
	$DayPass.modulate.a = 0
	
	$DayPass.visible = false

func call_character(c: Character) -> void:
	do_raycast = false

	print_debug("Character called: " + c.name)
	$%CallMenuBtn.visible = false
	DialogueManager.dialogue_ended.connect(_call_end)

	if c.id == "momiji" and QuestTracker.is_incomplete("ayamomi0.1"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/momiji_call0.dialogue"))
	elif c.id == "marisa" and QuestTracker.is_incomplete("reimari0"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/marisa_call0.dialogue"))
	else:
		DialogueManager.show_dialogue_balloon(GenericCallDialogue.construct_for(c))

func _call_end(r: DialogueResource) -> void:
	do_raycast = true
	$%CallMenuBtn.visible = true
	DialogueManager.dialogue_ended.disconnect(_call_end)

func _init() -> void:
	if Engine.is_editor_hint():
		return
	
	global = self
	CharacterTracker.load()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		$DayPass.visible = false
		return
	else:
		$DayPass.visible = true
	#await show_day_count(1)

	GlobalAudio.player2d = $AudioStreamPlayer2D
	GlobalAudio.player3d = $SubViewportContainer/SubViewport/World/AudioStreamPlayer3D
	$SubViewportContainer/SubViewport/World/DirectionalLight3D.rotate_x(deg_to_rad(-90))

	if GGT.is_changing_scene(): # this will be false if starting the scene with "Run current scene" or F6 shortcut
		await GGT.change_finished

	day_thread = Thread.new()
	day_thread.start(day_tracker.begin_loop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_day_tracker_character_goodbye(chara:Character) -> void:
	print_debug("Goodbye " + chara.name)
	state = GameState.WAITING
	Utilities.remove_all_children(sub)
	$Toolbar.visible = true
	sub.add_child(wait_interface.instantiate())
	#third_eye.disabled = true
	#$%CallMenuBtn.visible = false

func _on_day_tracker_character_hello(chara:Character) -> void:
	print_debug("Hello " + chara.name)
	state = GameState.CONVERSATION
	Utilities.remove_all_children(sub)
	$Toolbar.visible = false
	remove_child(cm)
	remove_child(qm)
	camera.reset_rotation()
	#third_eye.disabled = false
	#$%CallMenuBtn.visible = false

func _on_day_tracker_day_end() -> void:
	print_debug("DAY ENDED")
	state = GameState.IDLE
	Utilities.remove_all_children(sub)
	$Toolbar.visible = true
	#sub.add_child(idle_interface.instantiate())
	#third_eye.disabled = true
	#$%CallMenuBtn.visible = true
	do_raycast = true

func _on_day_tracker_day_start() -> void:
	#day_tracker.stop_what_you_are_doing = true
	await show_day_count(day_tracker.current_day.number)
	$SubViewportContainer/SubViewport/World/Lights.visible = true
	$%NewDayBtn.visible = true
	#day_tracker.stop_what_you_are_doing = false

	state = GameState.WAITING
	Utilities.remove_all_children(sub)
	#third_eye.disabled = true
	$Toolbar.visible = true
	#$%CallMenuBtn.visible = false
	do_raycast = false

func _on_third_eye_pressed() -> void:
	match day_tracker.curernt_character.id:
		"reimu":
			InteractionTracker.reimu_knowledge = true

func _on_call_menu_btn_pressed() -> void:
	#$%CallMenuBtn.visible = false
	do_raycast = false
	cm = call_menu.instantiate()
	add_child(cm)
	#$%CallMenuBtn.visible = true

func _on_quest_menu_btn_pressed() -> void:
	#$%QuestMenuBtn.visible = false
	do_raycast = false
	qm = quest_menu.instantiate()
	add_child(qm)
	#$%QuestMenuBtn.visible = true

func _on_new_day_btn_pressed() -> void:
	new_day()
