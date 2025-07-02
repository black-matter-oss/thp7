class_name GamePlayer
extends CharacterBody3D

const SPEED = 320.0
const JUMP_VELOCITY = 4.5

@onready var starting_position := position
@onready var ending_position_right := Vector3(position.x - 2, 0, position.z)
@onready var ending_position_left := Vector3(position.x + 2, 0, position.z)

@onready var camera := $satori/Camera3D as Camera3D
@onready var satori := $satori as Node3D

@onready var floor := get_parent().get_node("Floor") as MeshInstance3D
#@onready var ceiling := get_parent().get_node("Ceiling") as MeshInstance3D
@onready var corridors := get_parent().get_node("corridors") as Node3D
@onready var palace_area := get_parent().get_node("Colliders/PalaceArea2") as Area3D
@onready var palace_area2 := get_parent().get_node("Colliders/PalaceArea2") as Area3D
@onready var palace := get_parent().get_node("palace") as Node3D
@onready var collisions: Array[CollisionShape3D] = [
	get_parent().get_node("palace/room/Cylinder/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/room/Cube_003/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/room/Cube_004/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/arch/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/arch/StaticBody3D/CollisionShape3D2"),
	get_parent().get_node("palace/desk/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/desk/StaticBody3D/CollisionShape3D2"),
	get_parent().get_node("palace/desk/StaticBody3D/CollisionShape3D3"),
	get_parent().get_node("palace/desk/StaticBody3D/CollisionShape3D4"),
	get_parent().get_node("palace/desk/StaticBody3D/CollisionShape3D5"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D2"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D3"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D4"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D5"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D6")
]
@onready var thingies: Array[Node3D] = [
	get_parent().get_node("book"),
	get_parent().get_node("telephone"),
	#get_parent().get_node("Lights/Desk"),
	get_parent().get_node("Candles"),
	get_parent().get_node("clocks"),
	get_parent().get_node("radio"),
	get_parent().get_node("Chair")
]

@onready var chair_collisions: Array[CollisionShape3D] = [
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D2"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D3"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D4"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D5"),
	get_parent().get_node("Chair/StaticBody3D/CollisionShape3D6")
]

@onready var corridor_start_position := Vector3(0, 0, 1.848)

var sitting := true
var stood_up := false

func _unhandled_input(event: InputEvent) -> void:
	if GameplayInterface.global.state != GameplayInterface.GameState.IDLE or GameplayInterface.global.no_input:
		return
	
	if Input.is_action_just_released("stand_up"):
		#if sitting:
		#	position = ending_position
		sitting = false

func _process(delta: float) -> void:
	if GameplayInterface.global.state == GameplayInterface.GameState.CONVERSATION:
		sitting = true

	if sitting:
		(get_parent().get_node("Chair") as Node3D).rotation.y = get_node("satori").rotation.y

func _physics_process(delta: float) -> void:
	floor.global_position = Vector3(round(global_position.x), floor.global_position.y, round(global_position.z))
	#ceiling.global_position = Vector3(round(global_position.x / 50.0) * 50, ceiling.global_position.y, round(global_position.z / 50.0) * 50)

	if palace_area2.overlaps_body(self):
		if corridors.global_position != corridor_start_position:
			corridors.global_position = corridor_start_position
			
			# lighting breaks if we don't "restart" sdfgi after teleporting
			if GameWorld.global.environment.sdfgi_enabled:
				GameWorld.global.environment.sdfgi_enabled = false
				await get_tree().create_timer(0.1).timeout
				GameWorld.global.environment.sdfgi_enabled = true

		palace.visible = true
		for x in thingies:
			x.visible = true
		for x in collisions:
			x.disabled = false
	else:
		palace.visible = false
		for x in thingies:
			x.visible = false
		for x in collisions:
			x.disabled = true

		corridors.global_position.z = (round((global_position.z - 25) / 90.7391) - 1) * 90.7391 + corridor_start_position.z
		corridors.global_position.x = (round(global_position.x / 54.3439)) * 54.3439 + corridor_start_position.x

	if sitting:
		if stood_up:
			for x in chair_collisions:
				x.disabled = true
			
		#print(position)
		position = starting_position
		position.y = -0.2
		#print(position)
		stood_up = false
		return
	else:
		if not stood_up:
			var rot: Vector3 = get_node("satori").global_rotation_degrees

			if (rot.y < -70 and rot.y >= -180) or (rot.y <= 180 and rot.y > 120):
				position = camera.global_transform.origin - camera.global_transform.basis.z * 2.0
			elif rot.y > 15 and rot.y <= 120:
				position = ending_position_left
			elif rot.y <= 15 and rot.y >= -70:
				position = ending_position_right

			for x in chair_collisions:
				x.disabled = false

			stood_up = true
		position.y = 0.0

	if GameplayInterface.global.state != GameplayInterface.GameState.IDLE or GameplayInterface.global.no_input:
		return
	
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	var direction := (satori.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * delta
		velocity.z = direction.z * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

	if velocity != Vector3.ZERO and not $SpatialAudioPlayer3D.playing:
		$SpatialAudioPlayer3D.play()

	move_and_slide()
