extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	(get_parent() as GameplayInterface).do_raycast = true
	GameplayInterface.no_input = false
	get_parent().get_node("Toolbar").visible = true
	get_parent().remove_child(self)
	self.queue_free()
