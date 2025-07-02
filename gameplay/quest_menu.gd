extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		QuestTracker.add_quest(Ayamomi0Quest.new())
		QuestTracker.complete_quest("ayamomi0")
		QuestTracker.add_quest(Ayamomi01Quest.new())
	
	for k in QuestTracker.quests:
		var q := QuestTracker.quests[k]

		print(q.title)
		print(q.description)
		print(q.help)

		var title := RichTextLabel.new()
		title.size_flags_horizontal = Control.SIZE_FILL
		title.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		title.fit_content = true
		#var la := LabelSettings.new()
		#la.font_size = 16
		#la.font_color = Color.BLACK
		title.add_theme_font_size_override("normal_font_size", 16)
		title.text = q.title
		#if q.is_complete:
		#	la.font_color = Color.GRAY
		title.bbcode_enabled = true
		if q.is_complete:
			title.text = "[s]" + q.title + "[/s]"
		#title.label_settings = la
		title.text = "[color=black]" + title.text + "[/color]"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.tooltip_text = q.help

		var desc := RichTextLabel.new()
		desc.add_theme_font_size_override("normal_font_size", 12)
		desc.size_flags_horizontal = Control.SIZE_FILL
		desc.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		desc.fit_content = true
		#la = LabelSettings.new()
		desc.text = q.title
		#la.font_size = 12
		#la.font_color = Color.BLACK
		#if q.is_complete:
		#	la.font_color = Color.GRAY
		#desc.label_settings = la
		desc.bbcode_enabled = true
		if not q.is_complete:
			desc.text = q.description
		else:
			desc.text = "[s]" + q.description + "[/s]"
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc.text = "[color=black]" + desc.text + "[/color]"

		if q.is_complete:
			$%Completed.add_child(title)
			$%Completed.add_child(desc)
			$%Completed.add_child(HSeparator.new())
		else:
			$%Started.add_child(title)
			$%Started.add_child(desc)
			$%Started.add_child(HSeparator.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	(get_parent() as GameplayInterface).do_raycast = true
	GameplayInterface.no_input = false
	get_parent().get_node("Toolbar").visible = true
	get_parent().remove_child(self)
	GlobalAudio.play3d_p(GameWorld.global.get_node("book/SpatialAudioPlayer3D") as SpatialAudioPlayer3D, GlobalAudio.SFX_BOOK_CLOSE)
	GameWorld.global.get_node("book/Cube").visible = true
	GameWorld.global.get_node("book/Cube_002").visible = true
	GameWorld.global.get_node("book/Cube_003").visible = true
	self.queue_free()
