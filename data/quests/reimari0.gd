class_name Reimari0Quest
extends Quest

func _init() -> void:
	self.id = "reimari0"
	self.title = "Help Reimu get together with Marisa"
	self.description = "Call Marisa and push her closer to Reimu"
	self.help = "Call Marisa"

	self.quest_started.connect(func(q) -> void:
		CharacterTracker.getv("reimu").set_can_visit(false))
	self.quest_completed.connect(func(q) -> void:
		CharacterTracker.getv("reimu").set_can_visit(true))
