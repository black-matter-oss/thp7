class_name Rumicine2Quest
extends Quest

func _init() -> void:
	self.id = "rumicine2"
	self.title = "Anti-poisonous procurement"
	self.description = "Call Patchouli and convince her to lend Marisa her books"
	self.help = "Call Patchouli on the phone"

	self.quest_completed.connect(func(q) -> void:
		Rumicine0.success = 100)
