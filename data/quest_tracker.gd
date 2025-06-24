class_name QuestTracker
extends Object

static var quests: Dictionary[String, Quest] = {}

static func create_quest(a: String) -> void:
	var q: Quest

	match a:
		"ayamomi0":
			q = Ayamomi0Quest.new()
		"ayamomi0.1":
			q = Ayamomi01Quest.new()
		"reimari0":
			q = Reimari0Quest.new()
		_:
			assert(false)
	
	add_quest(q)

static func any_quest_active() -> bool:
	for k in quests:
		var q := quests[k]
		if not q.is_complete:
			return true
	return false

static func add_quest(q: Quest) -> void:
	quests[q.id] = q
	q.quest_started.emit(q)
	print("Quest started! " + q.id)

static func has_quest(id: String) -> bool:
	return id in quests

static func complete_quest(id: String) -> void:
	if id not in quests:
		print("Warning: quest " + id + " does not exist")
		return
	
	if quests[id].is_complete:
		return
	
	quests[id].is_complete = true
	quests[id].quest_completed.emit(quests[id])
	print("Quest complete! " + id)
	#quests.erase(id)

static func is_complete(id: String) -> bool:
	if id not in quests:
		return false
	return quests[id].is_complete

static func is_incomplete(id: String) -> bool:
	print(quests)
	if id not in quests:
		return false
	return not quests[id].is_complete
