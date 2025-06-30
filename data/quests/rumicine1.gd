class_name Rumicine1Quest
extends Quest

func _init() -> void:
	self.id = "rumicine1"
	self.title = "Anti-poisonous procurement"
	self.description = "Call Marisa and order a poison neutralising potion from her"
	self.help = "Call Marisa on the phone"

	self.quest_completed.connect(func(q) -> void:
		Rumicine0.success = 100)
