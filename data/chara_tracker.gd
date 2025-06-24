class_name CharacterTracker
extends Object

static var _characters : Dictionary[String, Character]

static func load() -> void:
	var satori := addv(Character.new("satori", "Satori Komeiji"))
	satori.dialogue_color = Color.from_rgba8(216, 138, 206)

	var remilia := addv(Character.new("remilia", "Remilia Scarlet"))
	remilia.dialogue_color = Color.from_rgba8(149, 139, 242)

	var flandre := addv(Character.new("flandre", "Flandre Scarlet"))
	flandre.relationships[satori] = 100
	#flandre.dialogue_color = Color.from_rgba8()

	# var wriggle := addv(Character.new("wriggle", "Wriggle Nightbug"))
	# wriggle.relationships[satori] = 160
	# wriggle.dialogue_color = Color.from_rgba8(96, 148, 72)

	# var mokou := addv(Character.new("mokou", "Fujiwara no Mokou"))
	# var kaguya := addv(Character.new("kaguya", "Kaguya Houraisan"))
	# mokou.relationships[kaguya] = -50
	# kaguya.relationships[mokou] = 250
	# mokou.dialogue_color = Color.from_rgba8(207, 94, 50)
	#kaguya.dialogue_color = Color.from_rgba8(80, 80, 80)

	# var maribel := addv(Character.new("maribel", "Maribel Hearn"))
	# maribel.dialogue_color = Color.from_rgba8(163, 144, 75)

	# var reimu := addv(Character.new("reimu", "Reimu Hakurei"))
	# reimu.dialogue_color = Color.from_rgba8(207, 91, 91)
	# var marisa := addv(Character.new("marisa", "Marisa Kirisame"))
	# marisa.dialogue_color = Color.from_rgba8(163, 144, 75)
	# reimu.relationships[marisa] = 350
	# marisa.relationships[reimu] = 200
	# marisa.set_can_visit(false)

	var kyouko := addv(Character.new("kyouko", "Kyouko Kasodani"))
	kyouko.dialogue_color = Color.from_rgba8(78, 105, 81)
	var mystia := addv(Character.new("mystia", "Mystia Lorelei"))
	mystia.dialogue_color = Color.from_rgba8(138, 109, 136)
	mystia.likes = "I like homemade food,\npunk rock,\nand Kyouko!"
	mystia.dislikes = "I absolutely hate junk and fast food.\nAnd people who don't collect their trash."

	# var okuu := addv(Character.new("okuu", "Utsuho Reiuji"))
	# var orin := addv(Character.new("orin", "Rin Kaenbyou"))
	# orin.dialogue_color = Color.from_rgba8(156, 61, 61)
	# okuu.dialogue_color = Color.from_rgba8(156, 86, 41)
	# okuu.relationships[orin] = 700
	# orin.relationships[okuu] = 650
	# orin.can_visit = func(x: Character) -> bool:
	# 	return CharacterTracker.getv("okuu").visited_times == 1

	var momiji := addv(Character.new("momiji", "Momiji Inubashiri"))
	momiji.dialogue_color = Color.from_rgba8(150, 150, 150)
	var aya := addv(Character.new("aya", "Aya Shameimaru"))
	momiji.relationships[aya] = 350
	aya.relationships[momiji] = 480
	aya.likes = "I love takoyaki and ramen. Of course, some strong alcohol is a necessity to each meal.\nMusic is a great addition too."
	aya.dislikes = "I don't really drink wine, sake or beer is much prefered.\nI also don't like crowded places."
	aya.third_eye_1 = "Wants to enter a romantic relationship with Momiji\n" + \
		"Loves takoyaki and ramen\n" + \
		"Loves strong alcohol\n" + \
		"Likes quiet places\n" + \
		"Likes music\n" + \
		"Dislikes wine\n" + \
		"Dislikes fancy restaurants"
	aya.dialogue_color = Color.from_rgba8(112, 112, 112)

	#print("Setting up starting relationships")


	for id in _characters:
		if id.contains(" "):
			continue
		
		print("Loading dialogues for " + id)
		_characters[id].load_dialogues()
		print("Loading portraits for " + id)
		_characters[id].load_portraits()

static func addv(v: Character) -> Character:
	_characters[v.id] = v
	_characters[v.name] = v
	return v

static func getv(id: String) -> Character:
	return _characters[id]
