class_name InteractionTracker
extends Object

static var wriggle_action: int = -1
static var okuu_action: int = -1
static var reimu_knowledge: bool = false
static var momiji_confessed: bool = false
static var kyouko_funny: bool = false
static var kyouko_propose: int = -1
static var love_protocol: bool = false
static var rumicine_poison: bool = false

static func bad_choice(chh: Character = null) -> void:
	#GlobalAudio.no = true
	GameplayInterface.global.radio_player.stream_paused = true
	GlobalAudio.play2d(GlobalAudio.SFX_NOISE1)

	var c: Character = chh
	if not c:
		c = GameplayInterface.global.day_tracker.curernt_character

	var doll := Doll.make_random(c.dialogue_color)
	GameWorld.global.get_node("Dolls").add_child(doll)
	if GameplayInterface.global.day_tracker.final_day:
		doll.position = Vector3(
			randf_range(-8, 8),
			21,
			randf_range(-20, -5)
		)
	else:
		doll.position = Vector3(
			randf_range(-11, 11),
			21,
			randf_range(-42, -28)
		)
	doll.rotation_degrees = Vector3(
		randf_range(0, 360),
		randf_range(0, 360),
		randf_range(0, 360)
	)

static func change_relationship(a: String, b: String, change: int) -> void:
	var ca := CharacterTracker.getv(a)
	var cb := CharacterTracker.getv(b)

	if cb not in ca.relationships:
		ca.relationships[cb] = change
	else:
		ca.relationships[cb] += change
	
	print(ca.relationships)
	print_debug("Changed relationship of " + cb.name + " to " + ca.name + " by " + str(change))

static func set_relationship(a: String, b: String, v: int) -> void:
	var ca := CharacterTracker.getv(a)
	var cb := CharacterTracker.getv(b)
	ca.relationships[cb] = v
	
	print_debug("Set relationship of " + cb.name + " to " + ca.name + " to " + str(v))

static func get_relationship(a: String, b: String) -> int:
	var ca := CharacterTracker.getv(a)
	var cb := CharacterTracker.getv(b)

	if cb not in ca.relationships:
		return 0

	return ca.relationships[cb]
