extends Cap

class_name ExponentialCap
## Mathematical description over at [url]https://www.desmos.com/calculator/qnrenvihpf[/url]

var _thickness: float
var _radius: float
var _exponent: float
var _height: float

var _offset: float

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_thickness = 1.0 - _parameters["thickness"]
	_radius = _parameters["radius"]
	_exponent = _parameters["exponent"]
	_height = _parameters["height"]
	
	_offset = -_height * _thickness
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, _height + _offset, 0.0)
	elif _parameter == 1.0:
		return Vector3(0.0, 0.0, 0.0)
	
	const treshold = 0.8
	var bottom = (_parameter > treshold)
	var effective_parameter = _parameter
	
	if bottom:
		effective_parameter = 1 - effective_parameter
		effective_parameter /= (1 - treshold)
	else:
		effective_parameter /= treshold
	
	var result = Vector3(0.0, _height * cos(effective_parameter * PI / 2.0), 0.0)
	
	var effective_radius = pow(effective_parameter, _exponent) * _radius
	result.x = effective_radius * cos(_angle)
	result.z = effective_radius * sin(_angle)
	
	if bottom:
		result.y *= (1 - effective_parameter) * treshold
	
	result.y += _offset
	
	return result

func get_face_direction():
	return true

func _get_precision():
	return 100

func _get_parameter_to_angle_precision_ratio():
	return 1.0
