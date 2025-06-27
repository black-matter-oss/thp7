class_name Ayamomi0
extends Object

static var date_success_chance: int = 0
static var date_success: int = -1

static var lalala: bool = false

static var lh_picked: bool = false
static var choice0: int = -1
static var choice1: int = -1
static var choice2: int = -1

static func date() -> bool:
	if date_success == -1:
		if randi_range(1, 100) <= date_success_chance:
			date_success = 1
		else:
			date_success = 0
	return date_success == 1

static func meowymeow() -> bool:
	if randi_range(1, 100) <= 30:
		return true
	return false

static func meowymeow2() -> bool:
	if randi_range(1, 100) <= 60:
		InteractionTracker.momiji_confessed = true
		return true
	return false

static func grahtewi() -> void:
	if randi_range(1, 100) <= 60:
		InteractionTracker.change_relationship("aya", "momiji", 150)
		InteractionTracker.change_relationship("momiji", "aya", 150)
	else:
		InteractionTracker.change_relationship("aya", "momiji", -70)
		InteractionTracker.change_relationship("momiji", "aya", -70)

static func reset() -> void:
	date_success_chance = 0
	date_success = -1

	lalala = false

	lh_picked = false
	choice0 = -1
	choice1 = -1
	choice2 = -1

	QuestTracker.remove_quest("ayamomi0")
	QuestTracker.remove_quest("ayamomi0.1")
