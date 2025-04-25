extends MeshComponent

class_name StraightStipe

var _height: float
var _thickness: float
var _thickness_difference: float
var _middle_point: float
var _curve_span: float

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_height = _parameters["height"]
	_thickness = _parameters["thickness"]
	_thickness_difference = _parameters["thickness difference"]
	_middle_point = _parameters["middle point"]
	_curve_span = _parameters["curve span"]
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

func get_cap_direction():
	return Vector3(0.0, 1.0, 0.0)
	
func get_cap_origin():
	return Vector3(0.0, _height, 0.0)

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, _height, 0.0)
	elif _parameter != 1.0:
		var thickness_helper = 2.0 * (-0.5 + _middle_point + _curve_span * _parameter)
		var r: float = _thickness + _thickness_difference * (1.0 - thickness_helper * thickness_helper)
		return Vector3(r * cos(_angle), _height * (1.0 - _parameter), r * sin(_angle))
	else:
		return Vector3(0.0, 0.0, 0.0)

func get_face_direction():
	return true

func _get_precision():
	return 20

func _get_parameter_to_angle_precision_ratio():
	return 1.0
