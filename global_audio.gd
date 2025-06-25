class_name GlobalAudio
extends Object

const SFX_HIT_HURT := preload("res://resources/sfx/hitHurt.wav")
const SFX_TONE := preload("res://resources/sfx/tone.wav")

static var player2d : AudioStreamPlayer2D
static var player3d : AudioStreamPlayer3D

static func play2d(audio) -> void:
	player2d.stream = audio
	player2d.play()

static func play3d(audio, position: Vector3 = player3d.position) -> void:
	player3d.stream = audio
	player3d.position = position
	player3d.play()
