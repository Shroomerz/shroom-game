extends Node3D
class_name ShroomShape

var _cap
var _leg

const _cap_mesh_name = "CapMesh"
const _leg_mesh_name = "LegMesh"

func _init(c_cap :Cap = null, c_leg :Leg = null):
	set_cap(c_cap)
	set_leg(c_leg)

func set_cap(c_cap :Cap):
	_cap = c_cap
	
func get_cap():
	return _cap

func set_leg(c_leg :Leg):
	_leg = c_leg
	
func get_leg():
	return _leg

func commit():
	if (get_node(_cap_mesh_name) != null):
		get_node(_cap_mesh_name).free()
	if (get_node(_leg_mesh_name) != null):
		get_node(_leg_mesh_name).free()
	
	var cap_mesh = ParametricPolarMesher.get_mesh(_cap)
	var leg_mesh = ParametricPolarMesher.get_mesh(_leg)
	var cap_to_leg_translation = _leg.get_cap_origin()
	var cap_to_leg_rotation = _leg.get_cap_direction()
	
	var cap_mesh_instance = MeshInstance3D.new()
	cap_mesh_instance.name = _cap_mesh_name
	cap_mesh_instance.mesh = cap_mesh
	
	var leg_mesh_instance = MeshInstance3D.new()
	leg_mesh_instance.name = _leg_mesh_name
	leg_mesh_instance.mesh = leg_mesh
	
	cap_mesh_instance.position = cap_to_leg_translation
	cap_mesh_instance.rotate(Vector3(0.0, 1.0, 0.0).cross(cap_to_leg_rotation).normalized(), acos(cap_to_leg_rotation.y))
	
	add_child(cap_mesh_instance)
	add_child(leg_mesh_instance)
