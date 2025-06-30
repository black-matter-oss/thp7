class_name Satoremi0Quest
extends Quest

func _init() -> void:
	self.id = "satoremi0"
	self.title = "Remilia Scarlet"
	self.description = "Call Remilia and check on her"
	self.help = "Call Remilia on the phone"

	self.quest_started.connect(func(q) -> void:
		CharacterTracker.getv("remilia").set_can_visit(false))
	self.quest_completed.connect(func(q) -> void:
		CharacterTracker.getv("remilia").set_can_visit(false))
