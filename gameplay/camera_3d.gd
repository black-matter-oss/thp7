class_name WorldCamera
extends Camera3D

var mm = Input.MOUSE_MODE_VISIBLE
var mlp = Vector2(0, 0)
var mouse_sens: float = 0.005
var do_raycast := true

const oshader := preload("res://resources/outline.gdshader")
var osm := ShaderMaterial.new()

var raycast_result: Dictionary

@onready var lamp_area := get_parent().get_node("Colliders/Lamp")
@onready var lamp: Array[MeshInstance3D] = [
	get_parent().get_node("palace/Sphere") as MeshInstance3D,
	get_parent().get_node("palace/Cylinder_002") as MeshInstance3D,
	get_parent().get_node("palace/Cylinder_003") as MeshInstance3D
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	osm.shader = oshader


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.mouse_mode = mm

func _physics_process(delta: float) -> void:
	if not do_raycast:
		return
	
	var space_state := get_world_3d().direct_space_state
	var mousepos := get_viewport().get_mouse_position()

	var origin = project_ray_origin(mousepos)
	var end = origin + project_ray_normal(mousepos) * 1000
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true

	raycast_result = space_state.intersect_ray(query)
	print(raycast_result)

	if raycast_result.is_empty():
		_unhighlight(lamp)
		return

	if raycast_result["collider"] == lamp_area:
		_highlight(lamp)
	else:
		_unhighlight(lamp)

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				#mlp = get_viewport().get_mouse_position()
				mm = Input.MOUSE_MODE_CAPTURED
			else:
				mm = Input.MOUSE_MODE_VISIBLE
				#get_viewport().warp_mouse(mlp)
		
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			do_raycast = true
	
	if event is InputEventMouseMotion and mm == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sens)
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sens, deg_to_rad(-89.9), deg_to_rad(89.9))
