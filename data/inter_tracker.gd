class_name InteractionTracker
extends Object

static var wriggle_action: int = -1
static var okuu_action: int = -1
static var reimu_knowledge: bool = false
static var momiji_confessed: bool = false
static var kyouko_funny: bool = false
static var kyouko_propose: int = -1

static func change_relationship(a: String, b: String, change: int) -> void:
	var ca := CharacterTracker.getv(a)
	var cb := CharacterTracker.getv(b)

	if cb not in ca.relationships:
		ca.relationships[cb] = change
	else:
		ca.relationships[cb] += change
	
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
