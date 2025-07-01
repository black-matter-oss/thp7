class_name Character
extends Object

var name: String
var id: String

var relationships: Dictionary[Character, int]

var dialogue_progress: int
var dialogues: Array[DialogueResource]

var portraits: Dictionary[String, Texture2D]
var current_emotion: String = "neutral"

var can_visit: Callable = func(c: Character) -> bool: return true
var visited_times: int = 0
var next_visit: String = ""

var data: Dictionary = {}

var dialogue_color: Color = Color.from_rgba8(227, 167, 111)

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

var likes: String = ""
var dislikes: String = ""

var loves: Character = null

var to_reset := false
var was_reset := false

var can_call := false

func _init(id: String = "", name: String = ""):
	self.name = name
	self.id = id

func reset() -> void:
	loves = null
	dialogue_progress = 0
	visited_times = 0
	set_can_visit(true)
	next_visit = ""
	to_reset = true
	print("Character reset: " + name)
	GlobalAudio.play2d(GlobalAudio.SFX_TONE)
	was_reset = true

func reset2() -> void:
	relationships[CharacterTracker.getv("satori")] = 0
	to_reset = false

func load_dialogues(epck: PCKPacker) -> void:
	const base_path := "res://resources/dialogues/"

	print_debug("Dialogue directory for character: " + base_path + id)
	var dir := DirAccess.open(base_path + id)
	if not dir:
		set_can_visit(false)
		print("Warning: " + name + " has no dialogues; cannot visit")
		return
	
	var files := dir.get_files()
	print_debug("Files: " + ",".join(files))

	#while file != "":
	for file in files:
		if not file.ends_with(".dialogue"):
			#file = dir.get_next()
			continue
		
		var dr := load(base_path + id + "/" + file)
		
		dialogues.append(dr)
		print_debug("Loaded dialogue " + file + " for " + name)

		# we need to do weird shit for dialogues because they're not being exported in the way i want them to be part 2
		if OS.is_debug_build():
			epck.add_file(base_path + id + "/" + file, base_path + id + "/" + file)
			print("DEBUG BUILD: ADDED TO DIALOGUE PCK PATCH " + base_path + id + "/" + file)

		#file = dir.get_next()
	
	#dir.list_dir_end()

	if dialogues.size() == 0:
		set_can_visit(false)
		print("Warning: " + name + " has no dialogues; cannot visit")
		return

func load_portraits(epck: PCKPacker) -> void:
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
		var a := fp
		var res := load(fp)

		if not res:
			a = fp.replace(id, "generic")
			res = load(fp.replace(id, "generic"))
			print_debug("Loaded generic portrait for " + name)
		else:
			print_debug("Loaded portrait " + file + " for " + name)

		# we need to do weird shit for portraits too because they're not being exported in the way i want them to be part 2
		if OS.is_debug_build():
			epck.add_file(a, a)
			print("DEBUG BUILD: ADDED TO CHARACTERS PCK PATCH " + a)

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
	# 	set_can_visit(false)
	# 	print(name + " has no dialogues left and won't be able to visit anymore")

func set_can_visit(can: bool) -> void:
	can_visit = func(c: Character) -> bool: return can

func set_can_call(can: bool) -> void:
	can_call = can

static func unlove(a: String, b: String) -> void:
	pass

static func love(a: String, b: String) -> void:
	pass

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
