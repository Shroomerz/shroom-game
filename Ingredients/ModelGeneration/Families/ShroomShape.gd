extends Node3D
class_name ShroomShape

var _cap
var _stipe

const _cap_mesh_name = "CapMesh"
const _stipe_mesh_name = "StipeMesh"

func _init(c_cap :Cap = null, c_stipe :Stipe = null):
	set_cap(c_cap)
	set_stipe(c_stipe)

func set_cap(c_cap :Cap):
	_cap = c_cap
	
func get_cap():
	return _cap

func set_stipe(c_stipe :Stipe):
	_stipe = c_stipe
	
func get_stipe():
	return _stipe

func commit():
	if (get_node(_cap_mesh_name) != null):
		get_node(_cap_mesh_name).free()
	if (get_node(_stipe_mesh_name) != null):
		get_node(_stipe_mesh_name).free()
	
	var cap_mesh = _cap.get_mesh()
	var stipe_mesh = _stipe.get_mesh()
	var cap_to_stipe_translation = _stipe.get_cap_origin()
	var cap_to_stipe_rotation = _stipe.get_cap_direction()
	
	var cap_mesh_instance = MeshInstance3D.new()
	cap_mesh_instance.name = _cap_mesh_name
	cap_mesh_instance.mesh = cap_mesh
	
	var stipe_mesh_instance = MeshInstance3D.new()
	stipe_mesh_instance.name = _stipe_mesh_name
	stipe_mesh_instance.mesh = stipe_mesh
	
	cap_mesh_instance.position = cap_to_stipe_translation
	cap_mesh_instance.rotate(Vector3(0.0, 1.0, 0.0).cross(cap_to_stipe_rotation).normalized(), acos(cap_to_stipe_rotation.y))
	
	add_child(cap_mesh_instance)
	add_child(stipe_mesh_instance)
