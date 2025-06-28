extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$%mesh["blend_shapes/strike_before"] = 0
	$%mesh["blend_shapes/strike_after"] = 0

	await get_tree().create_timer(1.0).timeout
	DialogueManager.dialogue_ended.connect(_next)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue0.dialogue"))

func _next(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_next)

	if not MainMenu.calm_mode:
		$%TextureRect.visible = true
	else:
		$%ColorRect.visible = true

	$%mesh["blend_shapes/strike_before"] = 1

	for i in range(3):
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished

	$knife.visible = true

	$%TextureRect.visible = false
	$%ColorRect.visible = false

	DialogueManager.dialogue_ended.connect(_nnext)
	DialogueManager.show_dialogue_balloon(load("res://resources/special_dialogues/epilogue1.dialogue"))

func _nnext(d) -> void:
	DialogueManager.dialogue_ended.disconnect(_nnext)
	$AnimationPlayer.play("strike")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	const a := 0.0001
	if $knife.visible:
		$knife.position += Vector3(randf_range(-a, a), randf_range(-a, a), randf_range(-a, a))
