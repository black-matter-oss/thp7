@tool
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

		var title := Label.new()
		var la := LabelSettings.new()
		la.font_size = 24
		title.text = q.title
		if q.is_complete:
			la.font_color = Color.GRAY
		title.label_settings = la
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.tooltip_text = q.help
		$PanelContainer/ScrollContainer/VBoxContainer.add_child(title)

		var desc := Label.new()
		la = LabelSettings.new()
		desc.text = q.title
		if q.is_complete:
			la.font_color = Color.GRAY
		desc.label_settings = la
		if not q.is_complete:
			desc.text = q.description
		else:
			desc.text = "[s]" + q.description + "[/s]"
			#desc.bbcode_enabled = true
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		$PanelContainer/ScrollContainer/VBoxContainer.add_child(desc)

		$PanelContainer/ScrollContainer/VBoxContainer.add_child(HSeparator.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	(get_parent() as GameplayInterface).do_raycast = true
	GameplayInterface.no_input = false
	get_parent().remove_child(self)
	self.queue_free()
