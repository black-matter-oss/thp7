class_name WorldCamera
extends Camera3D

var mm = Input.MOUSE_MODE_VISIBLE
var mlp = Vector2(0, 0)
var mouse_sens: float = 0.005

const oshader := preload("res://resources/outline.gdshader")
var osm := ShaderMaterial.new()

@onready var reset_rot := self.rotation
@onready var reset_rot_p = get_parent().rotation
const RESET_DURATION := 0.5
const RESET_STEPS := 30

var raycast_result: Dictionary

# yippie
@onready var gi := get_parent().get_parent().get_parent().get_parent().get_parent().get_parent() as GameplayInterface

@onready var world := get_parent().get_parent().get_parent() as GameWorld

#@onready var lamp_area := world.get_node("Colliders/Lamp")
#@onready var lamp: Array[MeshInstance3D] = [
	#world.get_node("palace/Sphere") as MeshInstance3D,
	#world.get_node("palace/Cylinder_002") as MeshInstance3D,
	#world.get_node("palace/Cylinder_003") as MeshInstance3D
#]

@onready var phone_area := world.get_node("Colliders/Phone")
@onready var phone: Array[MeshInstance3D] = [
	world.get_node("telephone/Cube") as MeshInstance3D,
	world.get_node("telephone/Cube_001") as MeshInstance3D,
	world.get_node("telephone/phone handle") as MeshInstance3D
]

@onready var book_area := world.get_node("Colliders/Book")
@onready var book: Array[MeshInstance3D] = [
	world.get_node("book/Cube") as MeshInstance3D,
	world.get_node("book/Cube_002") as MeshInstance3D,
	world.get_node("book/Cube_003") as MeshInstance3D
]

@onready var radio_area := world.get_node("Colliders/Radio")
@onready var radio: Array[MeshInstance3D] = [
	world.get_node("radio/Cube") as MeshInstance3D,
	world.get_node("radio/Cube_001") as MeshInstance3D
]

@onready var chair_area := world.get_node("Chair/Area3D")
@onready var chair: Array[MeshInstance3D] = [
	world.get_node("Chair/Chair/chair/Cube_007") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cube_008") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cube") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cylinder") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cube_001") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cube_002") as MeshInstance3D,
	world.get_node("Chair/Chair/chair/Cube_005") as MeshInstance3D
]

func reset_rotation(quick: bool = false) -> void:
	mm = Input.MOUSE_MODE_VISIBLE

	var start_rot := rotation
	var start_rot_p = get_parent().rotation

	if quick:
		rotation = reset_rot
		get_parent().rotation = reset_rot_p
		return
	else:
		var delta1 := reset_rot - rotation
		var delta2 = reset_rot_p - get_parent().rotation
		
		var delta1_step := delta1 / RESET_STEPS
		var delta2_step = delta2 / RESET_STEPS

		for i in range(RESET_STEPS):
			rotation = start_rot + delta1_step * i
			get_parent().rotation = start_rot_p + delta2_step * i
			await get_tree().create_timer(RESET_DURATION / RESET_STEPS).timeout
	
	rotation = reset_rot
	get_parent().rotation = reset_rot_p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osm.shader = oshader

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.mouse_mode = mm

func _physics_process(delta: float) -> void:
	if not gi.do_raycast:
		raycast_result = {}
		#_unhighlight(lamp)
		_unhighlight(phone)
		_unhighlight(book)
		_unhighlight(radio)
		return
	
	var space_state := get_world_3d().direct_space_state
	var mousepos := get_viewport().get_mouse_position()

	var origin = project_ray_origin(mousepos)
	var end = origin + project_ray_normal(mousepos) * 1000
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	query.collision_mask = 2

	raycast_result = space_state.intersect_ray(query)
	#print(raycast_result)

	if raycast_result.is_empty():
		#_unhighlight(lamp)
		_unhighlight(phone)
		_unhighlight(book)
		_unhighlight(radio)
		_unhighlight(chair)
		return

	# if raycast_result["collider"] == lamp_area:
	# 	_highlight(lamp)
	# else:
	# 	_unhighlight(lamp)

	if raycast_result["collider"] == book_area:
		_highlight(book)
	else:
		_unhighlight(book)
	
	if raycast_result["collider"] == phone_area:
		_highlight(phone)
	else:
		_unhighlight(phone)
	
	if raycast_result["collider"] == radio_area:
		_highlight(radio)
	else:
		_unhighlight(radio)
	
	if raycast_result["collider"] == chair_area and not world.player.sitting:
		_highlight(chair)
	else:
		_unhighlight(chair)

	#do_raycast = false

func _highlight(a: Array[MeshInstance3D]) -> void:
	for x in a:
		var mesh := x.mesh
		var mat := mesh.surface_get_material(0)
		mat.next_pass = osm
func _unhighlight(a: Array[MeshInstance3D]) -> void:
	for x in a:
		var mesh := x.mesh
		var mat := mesh.surface_get_material(0)
		mat.next_pass = null

func _stuff(event: InputEvent) -> void:
	if GameplayInterface.global.no_input:
		mm = Input.MOUSE_MODE_VISIBLE
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				#mlp = get_viewport().get_mouse_position()
				mm = Input.MOUSE_MODE_CAPTURED
			else:
				mm = Input.MOUSE_MODE_VISIBLE

				if GameplayInterface.global.state == GameplayInterface.GameState.CONVERSATION:
					reset_rotation()
					#return
				#get_viewport().warp_mouse(mlp)
		
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not raycast_result.is_empty():
			# if raycast_result["collider"] == lamp_area:
			# 	(world.get_node("Lights/Desk") as Node3D).visible = !(world.get_node("Lights/Desk") as Node3D).visible
			#print(raycast_result)
			if raycast_result["collider"] == phone_area:
				gi._on_call_menu_btn_pressed()
			elif raycast_result["collider"] == book_area:
				gi._on_quest_menu_btn_pressed()
			elif raycast_result["collider"] == radio_area:
				gi._radio_toggle()
			elif raycast_result["collider"] == chair_area and not world.player.sitting:
				world.player.sitting = true
	
	if event is InputEventMouseMotion and mm == Input.MOUSE_MODE_CAPTURED:
		get_parent().rotate_y(-event.relative.x * mouse_sens)
		#get_parent().get_node("satori").rotate_y(-event.relative.x * mouse_sens)
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sens, deg_to_rad(-60), deg_to_rad(65))
