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
const pause_menu := preload("res://menus/options.tscn")
const tootel_menu := preload("res://gameplay/tootel.tscn")

@onready var day_tracker := $DayTracker as DayTracker
@onready var sub := $SubInterface
var state := GameState.WAITING

var day_thread: Thread

var cm: Node
var qm: Node
var tm: Node

static var global: GameplayInterface

@onready var camera: WorldCamera = $SubViewportContainer/SubViewport/World/Player/satori/Camera3D
var do_raycast := true

@onready var radio_player: AudioStreamPlayer3D = $SubViewportContainer/SubViewport/World/RadioPlayer
@onready var world := $SubViewportContainer/SubViewport/World as GameWorld
@onready var player := $SubViewportContainer/SubViewport/World/Player as GamePlayer

static var no_input := false
static var pause := false
static var nnd_quest := false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		GameConfig.save()

func new_day() -> void:
	print("New day!")
	$%NewDayBtn.visible = false
	#$SubViewportContainer/SubViewport/World/AnimationPlayer.play("day_pass")
	#$SubViewportContainer/SubViewport/World/Lights.visible = false
	if day_thread:
		day_thread.wait_to_finish()
	day_tracker.start_new_day()
	day_tracker.stop_what_you_are_doing = true
	day_thread = Thread.new()
	day_thread.start(day_tracker.begin_loop)

func show_day_count(d: int) -> void:
	#$DayPass.modulate.a = 0

	day_tracker.stop_what_you_are_doing = true

	$DayPass.visible = true
	$%DayInfo.text = "Day " + str(d)
	$%CharaInfo.text = "Today's visitors:"

	for c in day_tracker.current_day.characters_to_visit:
		$%CharaInfo.text += "\n" + c.name
	
	if day_tracker.current_day.characters_to_visit.size() == 0:
		$%CharaInfo.text += "\nNone\nIt's time to do your quests!"

	while $DayPass.modulate.a < 1:
		$DayPass.modulate.a += 0.01
		await get_tree().create_timer(0.01).timeout
	
	$DayPass.modulate.a = 1
	#camera.mm = Input.MOUSE_MODE_VISIBLE
	#var we := $SubViewportContainer/SubViewport/World/WorldEnvironment.environment as Environment
	#we.background_mode = Environment.BG_CLEAR_COLOR
	#player.position = player.starting_position
	player.sitting = true

	await get_tree().create_timer(3).timeout
	camera.mm = Input.MOUSE_MODE_VISIBLE
	camera.reset_rotation(true)

	while $DayPass.modulate.a > 0:
		$DayPass.modulate.a -= 0.01
		await get_tree().create_timer(0.01).timeout
	
	$DayPass.modulate.a = 0
	$DayPass.visible = false

	day_tracker.stop_what_you_are_doing = false

func call_character(c: Character) -> void:
	do_raycast = false
	no_input = true
	$Toolbar.visible = false

	print_debug("Character called: " + c.name)
	$%CallMenuBtn.visible = false
	world.get_node("Player/satori/Camera3D/phone handle").visible = true

	GlobalAudio.play2d_p($SubSFX, GlobalAudio.SFX_PHONE_CALL)
	await get_tree().create_timer(randf_range(2.0, 8.0)).timeout
	$SubSFX.stop()

	DialogueManager.dialogue_ended.connect(_call_end)

	if InteractionTracker.get_relationship(c.name, "satori") < -100 or not c.can_call:
		GlobalAudio.play2d_p($SubSFX, GlobalAudio.SFX_NOT_AVAILABLE)
		await get_tree().create_timer(GlobalAudio.SFX_NOT_AVAILABLE.get_length() - 0.8).timeout
		_call_end(null)
		#DialogueManager.show_dialogue_balloon(load("res://resources/generic_dialogues/call_no_answer.dialogue"))
		return
	
	# if c.id == "rinnosuke":
	# 	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/rinnosuke_call.dialogue"))
	if c.id == "momiji" and QuestTracker.is_incomplete("ayamomi0.1"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/momiji_call0.dialogue"))
	elif c.id == "marisa" and QuestTracker.is_incomplete("reimari0"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/marisa_call0.dialogue"))
	elif c.id == "aya" and QuestTracker.is_incomplete("ayamomi0"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/aya_call0.dialogue"))
	elif c.id == "remilia" and QuestTracker.is_incomplete("satoremi0"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/remilia_call0.dialogue"))
	elif c.id == "alice" and QuestTracker.is_incomplete("rumicine0"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/alice_call0.dialogue"))
	elif c.id == "patchouli" and InteractionTracker.rumicine_poison:
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/patchouli_call0.dialogue"))
	elif c.id == "marisa" and InteractionTracker.rumicine_poison:
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/marisa_call1.dialogue"))
	elif c.id == "patchouli" and QuestTracker.is_incomplete("rumicine2"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/patchouli_call1.dialogue"))
	elif c.id == "marisa" and QuestTracker.is_incomplete("rumicine1"):
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/marisa_call2.dialogue"))
	elif c.id == "remilia":
		DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/remilia_call.dialogue"))
	else:
		print("EXTREME WARNING (it's almost an error): Can call character but didn't find resource: " + c.name)
		GlobalAudio.play2d_p($SubSFX, GlobalAudio.SFX_NOT_AVAILABLE)
		await get_tree().create_timer(GlobalAudio.SFX_NOT_AVAILABLE.get_length() - 0.8).timeout
		_call_end(null)

	#DialogueManager.show_dialogue_balloon(GenericCallDialogue.construct_for(c))

func _call_end(r: DialogueResource) -> void:
	await get_tree().create_timer(1.0).timeout
	do_raycast = true
	no_input = false
	$%CallMenuBtn.visible = true
	$Toolbar.visible = true
	GlobalAudio.play2d_p($SubSFX, GlobalAudio.SFX_PHONE_PUT_DOWN)
	world.get_node("Player/satori/Camera3D/phone handle").visible = false
	world.get_node("telephone/phone handle").visible = true
	DialogueManager.dialogue_ended.disconnect(_call_end)

func _init() -> void:
	global = self
	CharacterTracker.load()

	ResourceLoader.load_threaded_request("res://epilogue/test.tscn")
	ResourceLoader.load_threaded_request("res://epilogue/viewporter.tscn")

func _input(event: InputEvent) -> void:
	if no_input or $DayPass.visible:
		return

	if Input.is_action_pressed("pause"):
		add_child(pause_menu.instantiate())
		no_input = true
		pause = true	
		#do_raycast = false

	camera._stuff(event)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Setting graphics settings for viewport")
	GameOptions.set_viewport_options($SubViewportContainer/SubViewport)

	world.get_node("AnimationPlayer3").play("warning_flash")

	if Engine.is_editor_hint():
		$DayPass.visible = false
		return
	else:
		$DayPass.visible = true
	#await show_day_count(1)

	GlobalAudio.player2d = $AudioStreamPlayer2D
	GlobalAudio.player3d = $SubViewportContainer/SubViewport/World/AudioStreamPlayer3D
	GlobalAudio.player2dv2 = $NyaaSFX

	$SubViewportContainer/SubViewport/World/DirectionalLight3D.rotate_x(deg_to_rad(-5))

	if GGT.is_changing_scene(): # this will be false if starting the scene with "Run current scene" or F6 shortcut
		await GGT.change_finished

	#day_thread = Thread.new()
	#day_thread.start(day_tracker.begin_loop)
	new_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fx := AudioServer.get_bus_effect(3, 0) as AudioEffectAmplify
	fx.volume_db = clamp(pow((camera.global_position - radio_player.global_position).length() * 0.22, 2) - 80, -80.0, 0.0)
	#print(fx.volume_db)

	if pause:
		#day_tracker.stop_what_you_are_doing = true
		var dialg := get_node_or_null("ExampleBalloon") as CanvasLayer
		if dialg:
			dialg.visible = false
	else:
		#day_tracker.stop_what_you_are_doing = false
		var dialg := get_node_or_null("ExampleBalloon") as CanvasLayer
		if dialg:
			dialg.visible = true

	if QuestTracker.any_quest_active():
		$%NewDayBtn.visible = false
		nnd_quest = true
	else:
		if nnd_quest and not day_tracker.final_day:
			$%NewDayBtn.visible = true

func _on_day_tracker_character_goodbye(chara:Character) -> void:
	print_debug("Goodbye " + chara.name)

	# GlobalAudio.play2d_p($Footstep, GlobalAudio.SFX_FOOTSTEP1)
	# await $Footstep.finished
	# GlobalAudio.play2d_p($Footstep, GlobalAudio.SFX_FOOTSTEP1)
	# await $Footstep.finished

	#world.change_character_sprite(chara.get_current_portrait())

	# if chara.was_reset:
	# 	world.get_node("CharacterSprite").visible = false
	# 	chara.was_reset = false
	# else:
	day_tracker.stop_what_you_are_doing = true
	await world.character_walkout($Footstep)

	#GlobalAudio.no = false
	if radio_player.stream_paused:
		if day_tracker.final_day:
			radio_player.stop()
		else:
			radio_player.stream_paused = false

	state = GameState.WAITING
	Utilities.remove_all_children(sub)
	#$Toolbar.visible = true
	sub.add_child(wait_interface.instantiate())
	#third_eye.disabled = true
	$%NewDayBtn.visible = false
	#$%CallMenuBtn.visible = false

	day_tracker.stop_what_you_are_doing = false

func _on_day_tracker_character_hello(chara:Character) -> void:
	print_debug("Hello " + chara.name)

	# GlobalAudio.play2d_p($Footstep, GlobalAudio.SFX_FOOTSTEP1)
	# await $Footstep.finished
	# GlobalAudio.play2d_p($Footstep, GlobalAudio.SFX_FOOTSTEP1)
	# await $Footstep.finished

	# The magical infinite boundry of dialogue emotion prediction
	var twond := chara.dialogues[chara.dialogue_progress].raw_text.split("\n")[1].split(" ")
	if not twond[2].begins_with("[#e="):
		chara.current_emotion = "neutral"
	else:
		var e := twond[2].replace("[#e=", "").replace("]", "")
		chara.current_emotion = e
	
	print("Starting dialogue emotion: " + chara.current_emotion)

	world.change_character_sprite(chara.get_current_portrait())
	await world.character_walkin($Footstep)

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

	GlobalAudio.play2d(GlobalAudio.SFX_BELL_LARGE)

	var dl := $SubViewportContainer/SubViewport/World/DirectionalLight3D as DirectionalLight3D
	while dl.light_energy > 0.0:
		dl.light_energy = clamp(dl.light_energy - 0.025, 0, 1.0)
		await get_tree().create_timer(0.07).timeout
	dl.light_energy = 0.0
	#dl.shadow_enabled = false

	world.get_node("palace/lantern/OmniLight3D").visible = false

	#($SubViewportContainer/SubViewport/World/Player as CharacterBody3D).translate(Vector3(0, 0.2, 0))
	#player.sitting = false
	#player.position = player.ending_position

	#var we := $SubViewportContainer/SubViewport/World/WorldEnvironment.environment as Environment
	# while we.ambient_light_energy > 0.1:
	# 	we.ambient_light_energy -= 0.025
	# 	await get_tree().create_timer(0.05).timeout
	# we.ambient_light_energy = 0.1
	#we.background_mode = Environment.BG_KEEP

	state = GameState.IDLE
	Utilities.remove_all_children(sub)
	$Toolbar.visible = true
	#sub.add_child(idle_interface.instantiate())
	#third_eye.disabled = true
	if not day_tracker.final_day:
		$%NewDayBtn.visible = true
	if not QuestTracker.any_quest_active():
		$%CallMenuBtn.visible = true
	do_raycast = true

	if day_tracker.final_day:
		(world.get_node("AnimationPlayer2") as AnimationPlayer).play("pcall")
		(world.get_node("telephone/SpatialAudioPlayer3D") as SpatialAudioPlayer3D).play()

func _on_day_tracker_day_start() -> void:
	print("DAY STARTED")

	# var we := $SubViewportContainer/SubViewport/World/WorldEnvironment.environment as Environment
	# while we.ambient_light_energy < 0.7:
	# 	we.ambient_light_energy += 0.025
	# 	await get_tree().create_timer(0.05).timeout
	# we.ambient_light_energy = 0.7

	day_tracker.stop_what_you_are_doing = true

	$%NewDayBtn.visible = false
	$Toolbar.visible = false

	var dl := $SubViewportContainer/SubViewport/World/DirectionalLight3D as DirectionalLight3D
	while dl.light_energy < 1.0:
		dl.light_energy = clamp(dl.light_energy + 0.025, 0, 1.0)
		await get_tree().create_timer(0.07).timeout
	dl.light_energy = 1.0
	#dl.shadow_enabled = true

	world.get_node("palace/lantern/OmniLight3D").visible = true

	no_input = true
	do_raycast = false

	#day_tracker.stop_what_you_are_doing = true
	
	#_radio_out()
	_radio_fo()
	await show_day_count(day_tracker.current_day.number)
	#chattered = true
	_radio_fi()
	#_radio_in()
	#$SubViewportContainer/SubViewport/World/Lights.visible = true
	#$%NewDayBtn.visible = true
	#day_tracker.stop_what_you_are_doing = false

	if not radio_player.stream:
		radio_player.finished.connect(_radio_in)
		chattered = true
		_radio_in()

	#($SubViewportContainer/SubViewport/World/clocks as Clocks).set_volume(0)

	state = GameState.WAITING
	Utilities.remove_all_children(sub)
	#third_eye.disabled = true
	$%CallMenuBtn.visible = false
	no_input = false

func _on_third_eye_pressed() -> void:
	match day_tracker.curernt_character.id:
		"reimu":
			InteractionTracker.reimu_knowledge = true

func _on_call_menu_btn_pressed() -> void:
	$Toolbar.visible = false

	if day_tracker.final_day:
		if OS.is_debug_build():
			InteractionTracker.bad_choice(CharacterTracker.getv("remilia"))
			InteractionTracker.bad_choice(CharacterTracker.getv("kyouko"))
			InteractionTracker.bad_choice(CharacterTracker.getv("patchouli"))
			InteractionTracker.bad_choice(CharacterTracker.getv("koakuma"))
			InteractionTracker.bad_choice(CharacterTracker.getv("reimu"))
			InteractionTracker.bad_choice(CharacterTracker.getv("marisa"))

		no_input = true

		print("The end is never the end is never the end is never the end")
		var we := $SubViewportContainer/SubViewport/World/WorldEnvironment.environment as Environment
		we.background_color = Environment.BG_KEEP
		
		# for x in world.get_all_children(world):
		# 	if x is Light3D:
		# 		x.visible = false

		GlobalAudio.play2d(GlobalAudio.SFX_NOISE1)

		var s := $SubViewportContainer.material as ShaderMaterial
		while s.get_shader_parameter("movement") < 1.0:
			s.set_shader_parameter("movement", clamp(s.get_shader_parameter("movement") + 0.01, 0.0, 1.0))
			await get_tree().create_timer(0.05).timeout
		s.set_shader_parameter("movement", 1.0)
		
		#await get_tree().create_timer(5).timeout

		# var n := 0
		# while n < 500:
		# 	var m: float = 0.0003 * (n / 2.0)

		# 	#world.rotate_x(m)
		# 	world.rotation_degrees.x = 180
		# 	world.scale.x += m / 4.0
		# 	world.scale.y += m
		# 	#world.rotate_y(-m * 3.0)
		# 	n += 1
		# 	print(n)
		# 	await get_tree().create_timer(0.007).timeout
		
		#print("okay!")
		var epilogue: PackedScene = ResourceLoader.load_threaded_get("res://epilogue/viewporter.tscn")
		assert(epilogue)

		var inst := epilogue.instantiate()

		for x in Doll.dolls:
			var doll := Doll.make_random(x, false, 0.25)
			doll.position = Vector3(
				randf_range(-1.5, 1.5),
				2.0,
				randf_range(1.0, 3.5)
			)
			doll.rotation_degrees = Vector3(
				0,
				randf_range(0, 360),
				randf_range(70, 110)
			)
			inst.get_node("SubViewportContainer/SubViewport/Test/Dolls").add_child(doll)

		get_tree().root.add_child(inst)
		get_tree().root.remove_child(self)
		queue_free()

	#$%CallMenuBtn.visible = false
	do_raycast = false
	cm = call_menu.instantiate()

	GlobalAudio.play2d(GlobalAudio.SFX_PHONE_PICK_UP)
	GameWorld.global.get_node("telephone/phone handle").visible = false

	add_child(cm)
	no_input = true
	#$%CallMenuBtn.visible = true

func _on_quest_menu_btn_pressed() -> void:
	# if day_tracker.final_day:
	# 	return
	
	$Toolbar.visible = false
	
	#$%QuestMenuBtn.visible = false
	do_raycast = false
	qm = quest_menu.instantiate()
	GlobalAudio.play3d_p(world.get_node("book/SpatialAudioPlayer3D") as SpatialAudioPlayer3D, GlobalAudio.SFX_BOOK_OPEN)
	add_child(qm)
	no_input = true
	#$%QuestMenuBtn.visible = true

func _on_new_day_btn_pressed() -> void:
	$Toolbar.visible = false
	if state != GameState.IDLE:
		return
	new_day()

func _radio_toggle() -> void:
	if radio_player.playing and not radio_player.stream_paused:
		radio_player.stream_paused = true
	else:
		radio_player.stream_paused = false

var chattered := false

func _radio_in() -> void:
	if not chattered:
		radio_player.stream = GlobalAudio.random_chatter()
		radio_player.play()
		chattered = true
		#get_tree().create_timer(radio_player.stream.get_length() + 0.1).timeout.connect(func() -> void:
			#print("radio chatter done")
			#radio_player.stop()
			#_radio_in())
		return
	
	#radio_player.
	chattered = false

	var fx: AudioEffectAmplify = AudioServer.get_bus_effect(2, 1)
	fx.volume_db = -40

	radio_player.stream = GlobalAudio.random_bgm()
	radio_player.play()

	#_rfx(fx)

	while fx.volume_db < 0:
		fx.volume_db += 1
		#print(fx.volume_db)
		await get_tree().create_timer(0.05).timeout

func _radio_fi() -> void:
	var fx: AudioEffectAmplify = AudioServer.get_bus_effect(2, 1)
	fx.volume_db = -40

	#_rfx(fx)

	while fx.volume_db < 0:
		fx.volume_db += 1
		#print(fx.volume_db)
		await get_tree().create_timer(0.05).timeout

func _radio_out() -> void:
	var fx: AudioEffectAmplify = AudioServer.get_bus_effect(2, 1)
	#fx.volume_db = 

	# radio_player.stream = GlobalAudio.random_bgm()
	# radio_player.play()

	#_rfx(fx)

	while fx.volume_db > -50:
		fx.volume_db -= 1
		#print(fx.volume_db)
		await get_tree().create_timer(0.05).timeout
	
	radio_player.stop()

func _radio_fo() -> void:
	var fx: AudioEffectAmplify = AudioServer.get_bus_effect(2, 1)
	#fx.volume_db = 

	# radio_player.stream = GlobalAudio.random_bgm()
	# radio_player.play()

	#_rfx(fx)

	while fx.volume_db > -50:
		fx.volume_db -= 1
		#print(fx.volume_db)
		await get_tree().create_timer(0.05).timeout

func _on_tootel_btn_pressed() -> void:
	$Toolbar.visible = false
	do_raycast = false
	tm = tootel_menu.instantiate()
	add_child(tm)
	no_input = true
