extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameOptions.set_viewport_options($SubViewportContainer/SubViewport)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
