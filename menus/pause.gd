extends Control

#const OPTIONS := preload("res://menus/options.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# func _on_button_pressed() -> void:
# 	add_child(OPTIONS.instantiate())


func _on_close_pressed() -> void:
	GameplayInterface.no_input = false
	GameplayInterface.pause = false
	get_parent().remove_child(self)
	queue_free()
