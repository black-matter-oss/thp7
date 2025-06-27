class_name GameWorld
extends Node3D

static var global: GameWorld

@onready var character_sprite: Sprite3D = $CharacterSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = self

func change_character_sprite(t: Texture2D) -> void:
	character_sprite.texture = t
	character_sprite.offset = Vector2(-t.get_size().x / 2, 0)

func character_walkin(ap: AudioStreamPlayer2D) -> void:
	character_sprite.visible = true

	$AnimationPlayer.play("chara_walkin")
	#$AnimationPlayer2.play("chara_walk")

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
