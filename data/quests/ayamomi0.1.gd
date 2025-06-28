class_name Ayamomi01Quest
extends Quest

func _init() -> void:
	self.id = "ayamomi0.1"
	self.title = "Help Momiji find out Aya's intentions"
	self.description = "Call Momiji back and tell her what you found out about Aya"
	self.help = "Call Momiji through the phone and speak with her"

	self.quest_completed.connect(func(q) -> void:
		CharacterTracker.getv("momiji").set_can_visit(true))
