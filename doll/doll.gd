class_name Doll
extends Object

const DOLL0 := preload("res://doll/doll0.tscn")
const DOLL1 := preload("res://doll/doll1.tscn")
const DOLL2 := preload("res://doll/doll2.tscn")
const DOLL3 := preload("res://doll/doll3.tscn")

static var dolls: Array[Color] = []

static func make_random(color: Color, add_arr: bool = true, scale := 1.0) -> Node3D:
	var m: Node3D

	var r := randi_range(0, 3)
	match r:
		0:
			m = DOLL0.instantiate()
		1:
			m = DOLL1.instantiate()
		2:
			m = DOLL2.instantiate()
		3:
			m = DOLL3.instantiate()

	var b := m.get_node("doll0/Plane") as MeshInstance3D
	var h := m.get_node("doll0/Icosphere") as MeshInstance3D

	b.mesh = b.mesh.duplicate()
	var mat := b.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.albedo_color = color
	b.mesh.surface_set_material(0, mat)

	h.mesh = h.mesh.duplicate()
	mat = h.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.albedo_color = color
	h.mesh.surface_set_material(0, mat)


	# scaling
	b.scale *= scale
	h.scale *= scale
	(m.get_node("doll0/Cylinder_001") as MeshInstance3D).scale *= scale
	(m.get_node("doll0/CollisionShape3D") as CollisionShape3D).scale *= scale
	(m.get_node("doll0/CollisionShape3D2") as CollisionShape3D).scale *= scale
	(m.get_node("doll0/CollisionShape3D3") as CollisionShape3D).scale *= scale


	#c.shape = h.mesh.create_trimesh_shape()
	#c1.shape = b.mesh.create_convex_shape()
	#d.add_child(c1)

	if add_arr:
		dolls.append(color)

	return m
