@tool
extends Control

var called := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		CharacterTracker.load()

	var charas_alpha: Dictionary[String, Character] = {}
	for i in range(0, CharacterTracker._characters.size(), 2):
		var cn: String = CharacterTracker._characters.keys()[i]
		var c := CharacterTracker.getv(cn)
		charas_alpha[c.name] = c

	charas_alpha.sort()

	for cn in charas_alpha:
		var c := charas_alpha[cn]

		if c.id == "satori" or c.id == "koishi":
			continue
		
		# they don't have phones
		if c.id == "rumia" or c.id == "wriggle" or c.id == "medicine":
			continue

		#var hbc := HBoxContainer.new()

		var b := Button.new()
		b.text = cn
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pressed.connect(func() -> void:
			var p := get_parent() as GameplayInterface
			called = true
			_on_close_pressed()
			p.call_character(c))
		#hbc.add_child(b)

		# var l := Label.new()
		# l.text = c.name
		# l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		# #l.set_anchors_preset(PRESET_CENTER_RIGHT)
		# l.size_flags_horizontal	 = Control.SIZE_EXPAND_FILL
		# hbc.add_child(l)

		$PanelContainer/ScrollContainer/VBoxContainer.add_child(b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	if not called:
		(get_parent() as GameplayInterface).do_raycast = true
		GameplayInterface.no_input = false
		get_parent().get_node("Toolbar").visible = true
	get_parent().remove_child(self)
	if not called:
		GlobalAudio.play2d(GlobalAudio.SFX_PHONE_PUT_DOWN)
		GameWorld.global.get_node("telephone/phone handle").visible = true
	self.queue_free()
