class_name GenericCallDialogue

static func construct_for(c: Character) -> DialogueResource:
	var f := FileAccess.open("res://resources/generic_dialogues/call.dialogue", FileAccess.READ)
	var g := f.get_as_text().replace("((c))", c.name)

	print_debug(g)

	return DialogueManager.create_resource_from_text(g)
