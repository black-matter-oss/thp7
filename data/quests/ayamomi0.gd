class_name Ayamomi0Quest
extends Quest

func _init() -> void:
	self.id = "ayamomi0"
	self.title = "Help Momiji find out Aya's intentions"
	self.description = "Check how Aya feels about Momiji by using your third eye when she comes over"
	self.help = "Call Aya over through the call menu and use your third eye on her"

	self.quest_started.connect(func(q) -> void:
		CharacterTracker.getv("momiji").set_can_visit(false)
		CharacterTracker.getv("aya").consents_mind_reading = true)
	self.quest_completed.connect(func(q) -> void:
		#CharacterTracker.getv("momiji").set_can_visit(true)
		QuestTracker.add_quest(Ayamomi01Quest.new())
		CharacterTracker.getv("aya").consents_mind_reading = false)
