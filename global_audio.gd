class_name GlobalAudio
extends Object

const SFX_HIT_HURT := preload("res://resources/sfx/hitHurt.wav")
const SFX_TONE := preload("res://resources/sfx/tone.wav")
const SFX_FOOTSTEP1 := preload("res://resources/sfx/footstep1.wav")
const SFX_FOOTSTEP2 := preload("res://resources/sfx/footstep2.wav")
const SFX_BELL_LARGE := preload("res://resources/sfx/bell_large.wav")
const SFX_CLOCK1 := preload("res://resources/sfx/clock0.ogg")
const SFX_CLOCK2 := preload("res://resources/sfx/clock1.ogg")

static var player2d : AudioStreamPlayer2D
static var player3d : AudioStreamPlayer3D

static func play2d(audio) -> void:
	play2d_p(player2d, audio)

static func play2d_p(p, audio) -> void:
	p.stream = audio
	p.play()

static func play3d(audio, position: Vector3 = player3d.position) -> void:
	play3d_p(player3d, audio, position)

static func play3d_p(p, audio, position: Vector3 = Vector3.INF) -> void:
	if position == Vector3.INF:
		position = p.global_position
	p.stream = audio
	p.position = position
	p.play()
