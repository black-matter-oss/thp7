class_name Utilities
extends Object

static func remove_all_children(node: Node, free: bool = true) -> void:
	for child in node.get_children():
		node.remove_child(child)
		if free:
			child.queue_free()
