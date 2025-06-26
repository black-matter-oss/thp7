class_name Corridor
extends Node3D

static var last_pos: Vector3 = Vector3.ZERO

const CORRIDOR := preload("res://gameplay/corridor.tscn")
var spawned := false

var passingBody: Node3D
var next: Corridor

@onready var p: Node3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name == "corridor":
		remove_child($SpawnAreaZMinus)
		remove_child($SpawnAreaZPlus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	if not passingBody:
# 		return
# 	if (global_position - passingBody.global_position).length() > 200:
# 		print("REMOVING CORRIDOR")
# 		get_parent().remove_child(self)
# 		if next:
# 			next.spawned = false
# 		self.queue_free()

func _on_spawn_area_z_body_entered(body: Node3D) -> void:
	if spawned:
		return
	
	var h := body as CharacterBody3D
	if (last_pos - h.global_position).length() < 0.5:
		return
	last_pos = h.global_position
	
	print("MOVING CORRIDOR")
	#passingBody = body

	# next = CORRIDOR.instantiate()
	# get_parent().add_child(next)
	# var a := global_position

	if h.velocity.z < 0:
		#print("SPAWNING -")
		#a -= Vector3(0, 0, 90.7377)
		# if a.z < 80:
		# 	get_parent().remove_child(next)
		# 	next.queue_free()
		# 	return
		p.global_position.z -= 90.7377
	else:
		p.global_position.z += 90.7377
		# print("SPAWNING +")
		# a += Vector3(0, 0, 90.7377)

	#next.global_position = a
	#spawned = true
