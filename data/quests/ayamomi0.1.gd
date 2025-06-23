class_name Ayamomi01Quest
extends Quest

func _init() -> void:
	self.id = "ayamomi0.1"
	self.title = "Help Momiji find out Aya's intentions"
	self.description = "Call Momiji and tell her what you found out about Aya"
	self.help = "Call Momiji over through the call menu and speak to her about Aya"

	self.quest_completed.connect(func(q) -> void:
		CharacterTracker.getv("momiji").set_can_visit(true))
