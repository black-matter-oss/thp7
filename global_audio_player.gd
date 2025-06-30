extends AudioStreamPlayer2D

func _enter_tree() -> void:
	get_tree().node_added.connect(func(n: Node) -> void:
		if n.name.begins_with("Response"):
			return
		
		if n is Button and not n.get_meta("no_click", false):
			print_debug("Click SFX bound to button: " + n.name)
			(n as Button).toggled.connect($ButtonClick.play))

func _play_click(v) -> void:
	$ButtonClick.play()
