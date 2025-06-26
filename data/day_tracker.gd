class_name DayTracker
extends Node

signal day_start
signal character_hello(chara: Character)
signal character_goodbye(chara: Character)
signal day_end

var current_day: Day
var current_dialogue_ended := true

var curernt_character: Character

var stop_what_you_are_doing := false

@onready var interface: GameplayInterface = get_parent()

func start_new_day() -> void:
	if not current_day:
		current_day = Day.new(1)
	else:
		current_day = Day.new(current_day.number + 1)

	seed(Time.get_ticks_usec())

	# character picking
	var k: Array[String] = []

	for i in range(0, CharacterTracker._characters.size(), 2):
		var c: String = CharacterTracker._characters.keys()[i]

		# we cannot visit ourselves :(
		if c.to_lower().contains("satori"):
			continue

		var ch := CharacterTracker.getv(c)
		if ch.can_visit.call(ch) == false:
			continue

		k.append(c)
	
	k.shuffle()

	# if OS.is_debug_build():
	# 	DebugDraw2D.begin_text_group("character_picking")
	# 	for i in range(k.size()):
	# 		DebugDraw2D.set_text("k[" + str(i) + "]", k[i], -1, Color.WHITE, 10)
	
	for i in range(randi_range(1, 3)):
		if i > k.size() - 1:
			break
		
		var c := CharacterTracker.getv(k[i])
		current_day.characters_to_visit.append(c)
		print("Character to visit today: " + c.name)

		if c.id == "orin" and CharacterTracker.getv("okuu").next_visit == "ask_date":
			# if orin visits today for satori to ask her about date stuff
			# then okuu will also visit in the same day
			print_debug("Okuurin event conditional 1 trigger; Okuu visits after Orin")
			current_day.characters_to_visit.append(CharacterTracker.getv("okuu"))

	if current_day.characters_to_visit.size() == 0 and not QuestTracker.any_quest_active():
		print("No characters able to visit and no quest is active, game has ended!")
		GGT.change_scene("res://gameplay/game_end.tscn")
		return

	day_start.emit.call_deferred()

func begin_loop() -> void:
	if not current_day:
		start_new_day()
	
	while not current_day.characters_to_visit.is_empty():
		if not current_dialogue_ended:
			continue
		
		# TODO activities when waiting for visitors
		var idle_time := 0
		if OS.is_debug_build():
			idle_time = randi_range(1, 2)
		else:
			idle_time = randi_range(4, 10)
		idle_time += 5 # for the day info to have time to show :D

		await get_tree().create_timer(idle_time).timeout

		# new character visits
		var c := current_day.characters_to_visit[0]
		character_hello.emit.call_deferred(c)

		curernt_character = c

		while interface.state != GameplayInterface.GameState.CONVERSATION:
			await get_tree().create_timer(0.1).timeout

		# character dialogue
		current_dialogue_ended = false
		c.show_next_dialogue.call_deferred()

		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		
		while not current_dialogue_ended:
			await get_tree().create_timer(0.5).timeout

		# goodbye
		c.visited_times += 1

		# yanderedev :(
		# if c.id == "okuu" and c.next_visit == "ask_date":
		# 	print_debug("Okuu conditional 1")
		# 	c.can_visit = func(x: Character) -> bool:
		# 		return CharacterTracker.getv("orin").visited_times == 1
		# elif c.id == "reimu" and c.next_visit == "confession":
		# 	print_debug("Reimu conditional 1")
		# 	c.can_visit = func(x: Character) -> bool:
		# 		return CharacterTracker.getv("marisa").visited_times == 1

		curernt_character = null
		character_goodbye.emit.call_deferred(c)
		current_day.characters_to_visit.remove_at(0)

		DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)

		if c.dialogue_progress > c.dialogues.size() - 1:
			print(c.name + " has no more dialogues left")
			c.set_can_visit(false)
	
		while interface.state != GameplayInterface.GameState.WAITING:
			await get_tree().create_timer(0.1).timeout

	day_end.emit.call_deferred()

func _on_dialogue_ended(d: DialogueResource) -> void:
		print("DIALOGUE ENDED")
		current_dialogue_ended = true
