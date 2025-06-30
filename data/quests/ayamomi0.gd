class_name Ayamomi0Quest
extends Quest

func _init() -> void:
	self.id = "ayamomi0"
	self.title = "Help Momiji find out Aya's intentions"
	self.description = "Call Aya and check how she feels about Momiji"
	self.help = "Call Aya over the phone"

	self.quest_started.connect(func(q) -> void:
		CharacterTracker.getv("momiji").set_can_visit(false)
		CharacterTracker.getv("aya").can_call = true)
	self.quest_completed.connect(func(q) -> void:
		#CharacterTracker.getv("momiji").set_can_visit(true)
		QuestTracker.add_quest(Ayamomi01Quest.new())
		CharacterTracker.getv("aya").can_call = false)
