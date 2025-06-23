class_name CharacterTracker
extends Object

static var _characters : Dictionary[String, Character]

static func load() -> void:
	var satori := addv(Character.new("satori", "Satori Komeiji"))

	# var flandre := addv(Character.new("flandre", "Flandre Scarlet"))
	# flandre.relationships[satori] = 100
	
	# var wriggle := addv(Character.new("wriggle", "Wriggle Nightbug"))
	# wriggle.relationships[satori] = 160

	# var mokou := addv(Character.new("mokou", "Fujiwara no Mokou"))
	# var kaguya := addv(Character.new("kaguya", "Kaguya Houraisan"))
	# mokou.relationships[kaguya] = -50
	# kaguya.relationships[mokou] = 250

	# var maribel := addv(Character.new("maribel", "Maribel Hearn"))

	var reimu := addv(Character.new("reimu", "Reimu Hakurei"))
	var marisa := addv(Character.new("marisa", "Marisa Kirisame"))
	reimu.relationships[marisa] = 350
	marisa.relationships[reimu] = 200
	marisa.set_can_visit(false)

	# var okuu := addv(Character.new("okuu", "Utsuho Reiuji"))
	# var orin := addv(Character.new("orin", "Rin Kaenbyou"))
	# okuu.relationships[orin] = 700
	# orin.relationships[okuu] = 650
	# orin.can_visit = func(x: Character) -> bool:
	# 	return CharacterTracker.getv("okuu").visited_times == 1

	# var momiji := addv(Character.new("momiji", "Momiji Inubashiri"))
	# var aya := addv(Character.new("aya", "Aya Shameimaru"))
	# momiji.relationships[aya] = 350
	# aya.relationships[momiji] = 480
	# aya.third_eye_1 = "Wants to enter a romantic relationship with Momiji\n" + \
	# 	"Loves takoyaki and ramen\n" + \
	# 	"Loves strong alcohol\n" + \
	# 	"Likes quiet places\n" + \
	# 	"Likes music\n" + \
	# 	"Dislikes wine\n" + \
	# 	"Dislikes fancy restaurants"

	print("Setting up starting relationships")


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
