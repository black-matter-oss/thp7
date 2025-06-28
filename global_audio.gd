class_name GlobalAudio
extends Object

const SFX_HIT_HURT := preload("res://resources/sfx/hitHurt.wav")
const SFX_TONE := preload("res://resources/sfx/tone.wav")
const SFX_FOOTSTEP1 := preload("res://resources/sfx/footstep1.wav")
const SFX_FOOTSTEP2 := preload("res://resources/sfx/footstep2.wav")
const SFX_BELL_LARGE := preload("res://resources/sfx/bell_large.wav")
const SFX_CLOCK1 := preload("res://resources/sfx/clock0.ogg")
const SFX_CLOCK2 := preload("res://resources/sfx/clock1.ogg")
const SFX_NOISE0 := preload("res://resources/sfx/noise0.wav")
const SFX_NOISE1 := preload("res://resources/sfx/noise1.ogg")
const SFX_NOISE2 := preload("res://resources/sfx/noise2.ogg")
const SFX_FOOTSTEP1_LOOP := preload("res://resources/sfx/footstep1_loop.wav")
const SFX_DISCONNECT := preload("res://resources/sfx/disconnect.wav")

const BGM_ENDING := preload("res://resources/music/special/Reunited.mp3")
const BGM_TITLE := preload("res://resources/music/special/Danse Morialta.mp3")

const BGM_DIR = "res://resources/music"
const CHATTER_DIR = "res://resources/sfx/chatter"

static var player2d : AudioStreamPlayer2D
static var player3d : AudioStreamPlayer3D

static var last_bgm: String

static func play2d(audio) -> void:
	play2d_p(player2d, audio)

static func play2d_p(p, audio) -> void:
	p.stream = audio
	p.play()

static func play3d(audio) -> void:
	play3d_p(player3d, audio)

static func play3d_p(p, audio) -> void:
	# if position == Vector3.INF:
	# 	position = p.global_position
	p.stream = audio
	#p.global_position = position
	p.play()

static func random_bgm() -> AudioStream:
	var dir := DirAccess.open(BGM_DIR)
	var rfiles := dir.get_files()
	var files: Array[String] = []

	for x in rfiles:
		if x.ends_with(".import") or x.ends_with(".txt"):
			continue
		files.append(x)
	
	var file: String = files.pick_random()

	if last_bgm == file:
		return random_bgm()
	last_bgm = file

	print("Random BGM picked: " + file)

	return load(BGM_DIR + "/" + file)

static func random_chatter() -> AudioStream:
	var dir := DirAccess.open(CHATTER_DIR)
	var rfiles := dir.get_files()
	var files: Array[String] = []

	for x in rfiles:
		if x.ends_with(".import") or x.ends_with(".txt"):
			continue
		files.append(x)
	
	var file: String = files.pick_random()

	print("Random chatter picked: " + file)

	return load(CHATTER_DIR + "/" + file)
