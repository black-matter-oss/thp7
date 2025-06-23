class_name Character
extends Object

var name: String
var id: String

var relationships: Dictionary[Character, int]

var dialogue_progress: int
var dialogues: Array[Resource]

var portraits: Dictionary[String, Texture2D]
var current_emotion: String = "neutral"

var can_visit: Callable = func(c: Character) -> bool: return true
var visited_times: int = 0
var next_visit: String = ""

var data: Dictionary = {}

var consents_mind_reading: bool = false
var third_eye_0: String:
	get:
		var a := ""
		for c in relationships:
			var v := relationships[c]

			if v == 0:
				continue
			
			if v < -100:
				a += "Hates"
			elif v >= -100 and v < 0:
				a += "Unfriendly towards"
			elif v > 0 and v <= 150:
				a += "Friendly towards"
			elif v > 150 and v <= 300:
				a += "Likes"
			elif v > 300 and v <= 430:
				a += "Has a crush on"
			elif v > 430 and v <= 500:
				a += "Is in love with"
			else:
				a += "Is together with"
			
			a += " "
			a += c.name
			a += " ("
			a += str(v)
			a += ")\n"

		return a

var third_eye_1: String = ""

func _init(id: String, name: String):
	self.name = name
	self.id = id

func load_dialogues() -> void:
	const base_path := "res://resources/dialogues/"

	var dir := DirAccess.open(base_path + id)
	if not dir:
		can_visit = func(c: Character) -> bool: return false
		print("Warning: " + name + " has no dialogues; cannot visit")
		return
	
	var files := dir.get_files()
	#var file := dir.get_next()

	#while file != "":
	for file in files:
		if not file.ends_with(".dialogue"):
			#file = dir.get_next()
			continue
		
		dialogues.append(load(base_path + id + "/" + file))
		print_debug("Loaded dialogue " + file + " for " + name)

		#file = dir.get_next()
	
	#dir.list_dir_end()

func load_portraits() -> void:
	const base_path := "res://resources/characters/"

	var dir := DirAccess.open(base_path + id)
	if not dir:
		print("Warning: " + name + " has no portraits, loading generic ones")
		#return
		dir = DirAccess.open(base_path + "generic")
	
	dir.list_dir_begin()
	var file := dir.get_next()

	while file != "":
		if not file.ends_with(".png"):
			file = dir.get_next()
			continue
		
		var emote := file.replace(".png", "")
		# var emote: Emotion = Emotion.NEUTRAL
		# match file:
		# 	"neutral.png":
		# 		emote = Emotion.NEUTRAL
		# 	"blush.png":
		# 		emote = Emotion.BLUSH
		# 	"happy.png":
		# 		emote = Emotion.HAPPY
		# 	"sad.png":
		# 		emote = Emotion.SAD
		# 	"angry.png":
		# 		emote = Emotion.ANGRY
		# 	"annoyed.png":
		# 		emote = Emotion.ANNOYED
		# 	"surprise.png":
		# 		emote = Emotion.SURPRISE
		# 	"thinking.png":
		# 		emote = Emotion.THINKING
		# 	"relaxed.png":
		# 		emote = Emotion.RELAXED
		# 	_:
		# 		printerr("UNKNOWN EMOTION: " + file)

		var fp := base_path + id + "/" + file
		var res := load(fp)

		if not res:
			res = load(fp.replace(id, "generic"))
			print_debug("Loaded generic portrait for " + name)
		else:
			print_debug("Loaded portrait " + file + " for " + name)

		portraits[emote] = res
		file = dir.get_next()
	
	dir.list_dir_end()

func get_portrait(emote: String) -> Texture2D:
	if not emote in portraits:
		print("Warning: " + name + " has no portrait for emotion " + emote)
		return portraits["neutral"]
		
	return portraits[emote]

func get_current_portrait() -> Texture2D:
	return get_portrait(current_emotion)

func show_next_dialogue() -> void:
	DialogueManager.show_dialogue_balloon(dialogues[dialogue_progress])
	dialogue_progress += 1

	# if dialogue_progress >= dialogues.size() - 1:
	# 	can_visit = func(c: Character) -> bool: return false

func set_can_visit(can: bool) -> void:
	can_visit = func(c: Character) -> bool: return can

# enum Emotion {

# 	NEUTRAL, # 0
# 	BLUSH, # 1
# 	HAPPY, # 2
# 	SAD, # 3
# 	ANGRY, # 4
# 	ANNOYED, # 5
# 	SURPRISE, # 6
# 	THINKING, # 7
# 	RELAXED, # 8
# }
