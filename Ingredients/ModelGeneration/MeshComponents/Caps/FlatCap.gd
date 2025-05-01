extends Cap

class_name FlatCap

var _thickness: float
var _radius: float

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_thickness = _parameters["thickness"]
	_radius = _parameters["radius"]
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, 0.0, 0.0)
	elif _parameter == 1.0:
		return Vector3(0.0, _thickness, 0.0)
	
	var result
	if _parameter <= 1.0 / 10.0:
		var effective_radius = _parameter * 10.0 * _radius
		result = Vector3(cos(_angle), 0.0, sin(_angle)) * effective_radius
	elif _parameter <= 9.0 / 10.0:
		var effective_parameter = (_parameter * 10.0 - 1.0) / 8.0
		var effective_radius = _radius + sin(effective_parameter * PI) * _thickness / 2.0
		result = Vector3(effective_radius * cos(_angle), (_thickness - cos(effective_parameter * PI) * _thickness) / 2.0, effective_radius * sin(_angle))
	else:
		var effective_radius = (10.0 - _parameter * 10.0) * _radius
		result = Vector3(cos(_angle) * effective_radius, _thickness, sin(_angle) * effective_radius)
	
	return result

func get_face_direction():
	return false

func _get_precision():
	return 20

func _get_parameter_to_angle_precision_ratio():
	return 0.3
