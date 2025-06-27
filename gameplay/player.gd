extends CharacterBody3D

const SPEED = 250.0
const JUMP_VELOCITY = 4.5

@onready var camera := $satori/Camera3D as Camera3D
@onready var satori := $satori as Node3D

@onready var floor := get_parent().get_node("Floor") as MeshInstance3D
@onready var corridors := get_parent().get_node("corridors") as Node3D
@onready var palace_area := get_parent().get_node("Colliders/PalaceArea2") as Area3D
@onready var palace_area2 := get_parent().get_node("Colliders/PalaceArea2") as Area3D
@onready var palace := get_parent().get_node("palace") as Node3D
@onready var collisions: Array[CollisionShape3D] = [
	get_parent().get_node("palace/Cube_005/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/Cube_006/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/Cube_010/StaticBody3D/CollisionShape3D"),
	get_parent().get_node("palace/Cube_011/StaticBody3D/CollisionShape3D")
]
@onready var thingies: Array[Node3D] = [
	get_parent().get_node("book"),
	get_parent().get_node("telephone"),
	#get_parent().get_node("Lights/Desk"),
	get_parent().get_node("Candles"),
	get_parent().get_node("clocks"),
	get_parent().get_node("radio")
]

func _physics_process(delta: float) -> void:
	if GameplayInterface.global.state != GameplayInterface.GameState.IDLE:
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

	floor.global_position = Vector3(round(global_position.x), 0, round(global_position.z))
	
	if palace_area2.overlaps_body(self):
		corridors.global_position = Vector3.ZERO

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

		corridors.global_position.z = (round((global_position.z - 25) / 90.7767) - 1) * 90.7767
		corridors.global_position.x = (round(global_position.x / 54.3439)) * 54.3439
