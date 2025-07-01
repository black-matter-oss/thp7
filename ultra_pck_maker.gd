class_name UltraPckMaker
extends Object

# static func portrait_pck() -> void:
# 	if not OS.is_debug_build():
# 		print("==== LOADING PORTRAITS PCK ====")
# 		if not ProjectSettings.load_resource_pack("character_portraits.pck"):
# 			print("ERROR")
# 		return
	
# 	var pck := PCKPacker.new()
# 	pck.pck_start("user://character_portraits.pck")

# 	var dir := DirAccess.open("res://resources/characters")
# 	dir.list_dir_begin()
# 	var fn = dir.get_next()
# 	while fn != "":
# 		pck.add_file("res://resources/characters/" + fn, "res://resources/characters/" + fn)
# 		print("PCK ADD PORTRAIT: " + "res://resources/characters/" + fn)
# 		fn = dir.get_next()
# 	dir.list_dir_end()

# 	pck.flush()

static var m_loaded := false
static func music_pck() -> void:
	if m_loaded:
		return
	m_loaded = true

	if not OS.is_debug_build():
		print("==== LOADING MUSIC PCK ====")
		if not ProjectSettings.load_resource_pack("music.pck"):
			print("ERROR")
		return
	
	var pck := PCKPacker.new()
	pck.pck_start("user://music.pck")

	var dir := DirAccess.open("res://resources/music")
	dir.list_dir_begin()
	var fn = dir.get_next()
	while fn != "":
		if fn.begins_with("special"):
			fn = dir.get_next()
			continue
		pck.add_file("res://resources/music/" + fn, "res://resources/music/" + fn)
		print("PCK ADD MUSIC: " + "res://resources/music/" + fn)
		fn = dir.get_next()
	dir.list_dir_end()

	pck.flush()

static var c_loaded := false
static func chatter_pck() -> void:
	if c_loaded:
		return
	c_loaded = true
	
	if not OS.is_debug_build():
		print("==== LOADING CHATTER PCK ====")
		if not ProjectSettings.load_resource_pack("radio_chatter.pck"):
			print("ERROR")
		return
	
	var pck := PCKPacker.new()
	pck.pck_start("user://radio_chatter.pck")

	var dir := DirAccess.open("res://resources/sfx/chatter")
	dir.list_dir_begin()
	var fn = dir.get_next()
	while fn != "":
		pck.add_file("res://resources/sfx/chatter/" + fn, "res://resources/sfx/chatter/" + fn)
		print("PCK ADD CHATTER: " + "res://resources/sfx/chatter/" + fn)
		fn = dir.get_next()
	dir.list_dir_end()

	pck.flush()
