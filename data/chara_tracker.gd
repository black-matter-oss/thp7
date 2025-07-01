class_name CharacterTracker
extends Object

static var _characters : Dictionary[String, Character]

static var _epck := PCKPacker.new()

static func load() -> void:
	# we need to do weird shit for dialogues because they're not being exported in the way i want them to be
	if not OS.is_debug_build():
		print("=== LOADING CHARACTER PCK PATCH ===")
		if not ProjectSettings.load_resource_pack("characters.pck"):
			print("FAILED!!!")
	else:
		print("DEBUG BUILD: MAKE CHARACTER PCK PATCH")
		_epck.pck_start("user://characters.pck")

	var satori := addv(Character.new("satori", "Satori Komeiji"))
	var koishi := addv(Character.new("koishi", "Koishi Komeiji"))
	satori.dialogue_color = Color.from_rgba8(145, 89, 138)

	var remilia := addv(Character.new("remilia", "Remilia Scarlet"))
	remilia.dialogue_color = Color.from_rgba8(103, 96, 168)
	remilia.can_call = true

	var flandre := addv(Character.new("flandre", "Flandre Scarlet"))
	flandre.relationships[satori] = 100
	flandre.dialogue_color = Color.from_rgba8(166, 133, 66)

	var wriggle := addv(Character.new("wriggle", "Wriggle Nightbug"))
	wriggle.relationships[satori] = 160
	wriggle.dialogue_color = Color.from_rgba8(96, 148, 72)

	if not MainMenu.no_kagumokou:
		print("Excluding Kagumokou")
		var mokou := addv(Character.new("mokou", "Fujiwara no Mokou"))
		var kaguya := addv(Character.new("kaguya", "Kaguya Houraisan"))
		mokou.relationships[kaguya] = -50
		kaguya.relationships[mokou] = 250
		mokou.dialogue_color = Color.from_rgba8(207, 94, 50)
		kaguya.dialogue_color = Color.from_rgba8(80, 80, 80)
		kaguya.set_can_visit(false)

	var reimu := addv(Character.new("reimu", "Reimu Hakurei"))
	reimu.dialogue_color = Color.from_rgba8(207, 91, 91)
	var marisa := addv(Character.new("marisa", "Marisa Kirisame"))
	marisa.dialogue_color = Color.from_rgba8(163, 144, 75)
	reimu.relationships[marisa] = 350
	marisa.relationships[reimu] = 200
	marisa.set_can_visit(false)

	var kyouko := addv(Character.new("kyouko", "Kyouko Kasodani"))
	kyouko.dialogue_color = Color.from_rgba8(78, 105, 81)
	var mystia := addv(Character.new("mystia", "Mystia Lorelei"))
	mystia.dialogue_color = Color.from_rgba8(138, 109, 136)
	mystia.can_call = true
	mystia.likes = "I like homemade food,\npunk rock,\nand Kyouko!"
	mystia.dislikes = "I absolutely hate junk and fast food.\nAnd people who don't collect their trash."

	var okuu := addv(Character.new("okuu", "Utsuho Reiuji"))
	var orin := addv(Character.new("orin", "Rin Kaenbyou"))
	orin.dialogue_color = Color.from_rgba8(156, 61, 61)
	okuu.dialogue_color = Color.from_rgba8(156, 86, 41)
	okuu.relationships[orin] = 700
	orin.relationships[okuu] = 650
	orin.set_can_visit(false)

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

	var patchouli := addv(Character.new("patchouli", "Patchouli Knowledge"))
	patchouli.dialogue_color = Color.from_rgba8(167, 74, 184)
	var koakuma := addv(Character.new("koakuma", "Koakuma"))
	koakuma.dialogue_color = Color.from_rgba8(184, 43, 39)
	koakuma.set_can_visit(false)

	var rumia := addv(Character.new("rumia", "Rumia"))
	rumia.dialogue_color = Color.from_rgba8(0, 0, 0)
	rumia.set_can_visit(false)
	var medicine := addv(Character.new("medicine", "Medicine Melancholy"))
	medicine.dialogue_color = Color.from_rgba8(130, 115, 69)

	var alice := addv(Character.new("alice", "Alice Margatroid"))
	alice.dialogue_color = Color.from_rgba8(130, 115, 69)

	var rinnosuke := addv(Character.new("rinnosuke", "Rinnosuke Morichika"))
	rinnosuke.dialogue_color = Color.from_rgba8(100, 100, 100)
	#rinnosuke.can_call = true

	for i in range(0, CharacterTracker._characters.size(), 2):
		var cn: String = CharacterTracker._characters.keys()[i]
		var c := _characters[cn]
		
		print("Loading dialogues for " + cn)
		c.load_dialogues(_epck)
		print("Loading portraits for " + cn)
		c.load_portraits(_epck)
	
	if OS.is_debug_build():
		print("DEBUG BUILD: ADDING SPECIAL DIALOGUES TO PCK PATCH")
		var dir := DirAccess.open("res://resources/special_dialogues")
		for x in dir.get_files():
			if x.ends_with(".dialogue"):
				_epck.add_file("res://resources/special_dialogues/" + x, "res://resources/special_dialogues/" + x)

		print("DEBUG BUILD: ADDING GENERIC DIALOGUES TO PCK PATCH")
		dir = DirAccess.open("res://resources/generic_dialogues")
		for x in dir.get_files():
			if x.ends_with(".dialogue"):
				_epck.add_file("res://resources/generic_dialogues/" + x, "res://resources/generic_dialogues/" + x)

		print("DEBUG BUILD: FINISH WRITING DIALOGUES PCK PATCH")
		_epck.flush()

static func addv(v: Character) -> Character:
	_characters[v.id] = v
	_characters[v.name] = v
	return v

static func getv(id: String) -> Character:
	if id not in _characters:
		return null
	return _characters[id]

static func love(a: String, b: String) -> void:
	var ca = CharacterTracker.getv(a)
	var cb = CharacterTracker.getv(b)
	ca.loves = cb
	cb.loves = ca

static func unlove(a: String, b: String) -> void:
	var ca = CharacterTracker.getv(a)
	var cb = CharacterTracker.getv(b)
	ca.loves = null
	cb.loves = null
	GlobalAudio.play2d(GlobalAudio.SFX_HIT_HURT)

static func is_love(a: String, b: String) -> bool:
	var ca = CharacterTracker.getv(a)
	var cb = CharacterTracker.getv(b)
	return ca.loves == cb and cb.loves == ca
