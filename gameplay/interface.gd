class_name GameplayInterface
extends Control

enum GameState {
	WAITING,
	CONVERSATION,
	IDLE
}

const idle_interface := preload("res://gameplay/idle.tscn")
const wait_interface := preload("res://gameplay/wait.tscn")
const call_menu := preload("res://gameplay/call_menu.tscn")
const quest_menu := preload("res://gameplay/quest_menu.tscn")

@onready var day_tracker := $DayTracker
@onready var sub := $SubInterface
var state := GameState.WAITING

var day_thread: Thread

func new_day() -> void:
	print("New day!")
	day_thread.wait_to_finish()
	day_tracker.start_new_day()
	day_thread = Thread.new()
	day_thread.start(day_tracker.begin_loop)

func call_character(c: Character) -> void:
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
	$%CallMenuBtn.visible = true
	DialogueManager.dialogue_ended.disconnect(_call_end)

func _init() -> void:
	CharacterTracker.load()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	sub.add_child(wait_interface.instantiate())
	#third_eye.disabled = true
	$%CallMenuBtn.visible = false

func _on_day_tracker_character_hello(chara:Character) -> void:
	print_debug("Hello " + chara.name)
	state = GameState.CONVERSATION
	Utilities.remove_all_children(sub)
	#third_eye.disabled = false
	$%CallMenuBtn.visible = false

func _on_day_tracker_day_end() -> void:
	print_debug("DAY ENDED")
	state = GameState.IDLE
	Utilities.remove_all_children(sub)
	sub.add_child(idle_interface.instantiate())
	#third_eye.disabled = true
	$%CallMenuBtn.visible = true

func _on_day_tracker_day_start() -> void:
	state = GameState.WAITING
	Utilities.remove_all_children(sub)
	#third_eye.disabled = true
	$%CallMenuBtn.visible = false

func _on_third_eye_pressed() -> void:
	match day_tracker.curernt_character.id:
		"reimu":
			InteractionTracker.reimu_knowledge = true

func _on_call_menu_btn_pressed() -> void:
	add_child(call_menu.instantiate())


func _on_quest_menu_btn_pressed() -> void:
	add_child(quest_menu.instantiate())
