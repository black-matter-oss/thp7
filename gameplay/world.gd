class_name GameWorld
extends Node3D

signal graphic_options_change()

static var global: GameWorld

@onready var character_sprite: Sprite3D = $CharacterSprite
@onready var environment: Environment = $WorldEnvironment.environment
@onready var player: GamePlayer = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = self
	print("Setting initial graphics settings for world")
	graphic_options_change.emit()

func _process(delta: float) -> void:
	if QuestTracker.any_quest_active():
		$book/Warning.visible = true
	else:
		$book/Warning.visible = false

func change_character_sprite(t: Texture2D) -> void:
	character_sprite.texture = t
	character_sprite.offset = Vector2(-t.get_size().x / 2, 0)

func character_walkin(ap: AudioStreamPlayer2D) -> void:
	$AnimationPlayer.play("chara_walkin")
	#$AnimationPlayer2.play("chara_walk")

	character_sprite.visible = true

	GlobalAudio.play2d_p(ap, GlobalAudio.SFX_FOOTSTEP1_LOOP)

	# var i := 0
	# while $AnimationPlayer.current_animation_position < $AnimationPlayer.current_animation_length:
	# 	character_sprite.position.z -= 0.2 * i
	# 	print(character_sprite.position)
	# 	await get_tree().create_timer(0.05).timeout
	# 	i += 1

	await $AnimationPlayer.animation_finished
	#$AnimationPlayer2.stop()
	ap.stop()

func character_walkout(ap: AudioStreamPlayer2D) -> void:
	$AnimationPlayer.play_backwards("chara_walkout_new")
	await get_tree().create_timer(0.5).timeout
	#$AnimationPlayer2.play("chara_walk")

	GlobalAudio.play2d_p(ap, GlobalAudio.SFX_FOOTSTEP1_LOOP)
	# while $AnimationPlayer.current_animation_position < $AnimationPlayer.current_animation_length:
	# 	character_sprite.position.z += 0.1
	# 	await get_tree().create_timer(0.1).timeout

	await $AnimationPlayer.animation_finished
	#$AnimationPlayer2.stop()
	ap.stop()

	character_sprite.visible = false

func get_all_children(in_node,arr: Array[Node]=[]) -> Array[Node]:
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func _on_graphic_options_change() -> void:
	match GameOptions.shadows:
		0: # disabled
			for x in get_all_children(self):
				if x is Light3D:
					x.shadow_enabled = false
		1: # some (directional lights)
			for x in get_all_children(self):
				if x.get_meta("no_shadow", false):
					return
				
				if x is DirectionalLight3D:
					x.shadow_enabled = true
				elif x is Light3D:
					x.shadow_enabled = false
		2: # all
			for x in get_all_children(self):
				if x.get_meta("no_shadow", false):
					return
				
				if x is Light3D:
					x.shadow_enabled = true
	
	environment.sdfgi_enabled = GameOptions.lights
	environment.ssr_enabled = GameOptions.reflections
