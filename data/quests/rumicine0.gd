class_name Rumicine0Quest
extends Quest

func _init() -> void:
	self.id = "rumicine0"
	self.title = "Help with Medicine's friendship"
	self.description = "Call Alice and organise a surprise for Medicine"
	self.help = "Call Alice on the phone"

	self.quest_started.connect(func(q) -> void:
		CharacterTracker.getv("alice").can_call = true)

	self.quest_completed.connect(func(q) -> void:
		CharacterTracker.getv("alice").can_call = false
		CharacterTracker.getv("medicine").set_can_visit(false)
		CharacterTracker.getv("rumia").set_can_visit(true))
