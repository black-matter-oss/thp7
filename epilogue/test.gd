extends Node3D

@onready var env := $Environment as EpilogueEnvironment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if not Engine.is_editor_hint():
	if not MainMenu.calm_mode:
		$%TextureRect.visible = true
	else:
		$%ColorRect.visible = true
	
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(2.5).timeout

	#  WAAAAA
	# for x in get_node("Dolls").get_children():
	# 	#print((x as Node3D).scale)
	# 	var a: RigidBody3D = x.get_child(0)
	# 	a.scale = Vector3(1, 1, 1)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	$%koimesh["blend_shapes/strike_before"] = 0
	$%koimesh["blend_shapes/strike_after"] = 0

	await get_tree().create_timer(1.0).timeout

	if $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stop()
	$%TextureRect.visible = false
	$%ColorRect.visible = false

	DialogueManager.dialogue_ended.connect(_next)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue0.dialogue"))

func _next(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_next)

	if not MainMenu.calm_mode:
		$%TextureRect.visible = true
	else:
		$%ColorRect.visible = true

	$%koimesh["blend_shapes/strike_before"] = 1

	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(2.5).timeout
	$AudioStreamPlayer2D.stop()

	$knife.visible = true
	$doll_ground.visible = true

	$chara/Cylinder_001.visible = false
	$chara/Icosphere.visible = false
	$chara/Plane.visible = false

	$doll_ground.visible = true

	$%TextureRect.visible = false
	$%ColorRect.visible = false

	DialogueManager.dialogue_ended.connect(_nnext)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue1.dialogue"))

func _nnext(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_nnext)
	$AnimationPlayer.play("strike")
	await get_tree().create_timer(2.8).timeout

	if not MainMenu.calm_mode:
		$%TextureRect.visible = true
	else:
		$%ColorRect.visible = true
	
	$AudioStreamPlayer2D.play()

	$chara/flan.visible = true
	$%flanmesh["blend_shapes/hug1"] = 1
	DialogueManager.dialogue_ended.connect(_nnnext)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue2.dialogue"))

func _nnnext(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_nnnext)

	$AudioStreamPlayer2D.stop()

	$%TextureRect.visible = false
	$%ColorRect.visible = false

	DialogueManager.dialogue_ended.connect(_nnnnext)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue3.dialogue"))

func _nnnnext(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_nnnnext)
	$AnimationPlayer.play("yippie")

	DialogueManager.dialogue_ended.connect(_finish)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue4.dialogue"))

func _finish(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_finish)
	$AnimationPlayer.play("flan_face")

	await get_tree().create_timer(1.0).timeout
	GlobalAudioPlayer.stream = GlobalAudio.BGM_ENDING
	GlobalAudioPlayer.play()

	$AudioStreamPlayer2D2.stop()
	#$AnimationPlayer.play("happy_day")
	await env.lighten_sky()
	
	# var ps := ($WorldEnvironment.environment as Environment).sky.sky_material as PhysicalSkyMaterial
	# #ps.rayleigh_color

	# var target := Color.from_rgba8(33, 59, 102)

	# #print("lalala")

	# #print(ps.rayleigh_color)
	# #print(target)

	# var secs = 3.0
	# var perSec = 20.0
	# var steps = secs * perSec
	# var stepR = (target.r - ps.rayleigh_color.r) / steps
	# var stepG = (target.g - ps.rayleigh_color.g) / steps
	# var stepB = (target.b - ps.rayleigh_color.b) / steps
	# var step = 0

	# # print(target.r)
	# # print(ps.rayleigh_color.r)
	# # print(target.g)
	# # print(ps.rayleigh_color.g)
	# # print(target.b)
	# # print(ps.rayleigh_color.b)

	# print(stepR)
	# print(stepG)
	# print(stepB)

	# while step < steps:
	# 	ps.rayleigh_color.r += stepR
	# 	ps.rayleigh_color.g += stepG
	# 	ps.rayleigh_color.b += stepB

	# 	#print(ps.rayleigh_color.r)
	# 	#print(ps.rayleigh)

	# 	step += 1
	# 	await get_tree().create_timer(1.0 / perSec).timeout

	#print("lilili")

	await get_tree().create_timer(1.0).timeout
	#$AnimationPlayer.play("close")
	$%ColorRect.color.a = 0
	$%ColorRect.visible = true

	while $%ColorRect.color.a < 1.0:
		$%ColorRect.color.a = clamp($%ColorRect.color.a + 0.02, 0.0, 1.0)
		await get_tree().create_timer(0.07).timeout
	$%ColorRect.color.a = 1.0

	await get_tree().create_timer(3.0).timeout
	GameConfig.file.set_value("game", "completed", true)

	print("If we got here, it means the game has been completed without any game-breaking bugs!!")
	print("Please send regards to the entire team (me) :)")
	print("Congratulations!!")

	#GGT.change_scene("res://menus/menu.tscn", { "ending": true })
	var menu = load("res://menus/menu.tscn").instantiate()
	GameConfig.save()
	get_tree().root.add_child(menu)
	get_tree().root.remove_child(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	const a := 0.0001
	const b := 1.0
	if $knife.visible:
		$knife.position += Vector3(randf_range(-a, a), randf_range(-a, a), randf_range(-a, a))
		$knife.rotation_degrees += Vector3(randf_range(-a, a), randf_range(-a, a), randf_range(-a, a))
