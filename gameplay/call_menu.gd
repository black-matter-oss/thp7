@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		CharacterTracker.load()
	
	for i in range(0, CharacterTracker._characters.size(), 2):
		var cn: String = CharacterTracker._characters.keys()[i]
		var c := CharacterTracker.getv(cn)

		if c.id == "satori":
			continue

		var hbc := HBoxContainer.new()

		var b := Button.new()
		b.text = "Call"
		b.pressed.connect(func() -> void:
			var p := get_parent() as GameplayInterface
			_on_close_pressed()
			p.call_character(c))
		hbc.add_child(b)

		var l := Label.new()
		l.text = c.name
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		l.set_anchors_preset(PRESET_CENTER_RIGHT)
		l.size_flags_horizontal	 = Control.SIZE_EXPAND_FILL
		hbc.add_child(l)

		$PanelContainer/ScrollContainer/VBoxContainer.add_child(hbc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	get_parent().remove_child(self)
	self.queue_free()
