class_name GameConfig
extends Object

static var file: ConfigFile = ConfigFile.new()

static func init() -> void:
	if file.load("user://settings.cfg") != OK:
		print("Warning: User data could not be loaded; this is normal on first startup")

static func save() -> void:
	file.save("user://settings.cfg")
	print("Configuration saved!")
