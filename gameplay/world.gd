class_name GameWorld
extends Node3D

static var global: GameWorld

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_corridor_move_area_body_entered(body:Node3D) -> void:
	pass # Replace with function body.
