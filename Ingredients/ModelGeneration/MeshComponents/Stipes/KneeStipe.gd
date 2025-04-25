extends MeshComponent

class_name KneeStipe

var _segments: Array
var _thickness: float
var _thickness_difference: float

var _curve: Curve3D

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_segments = _parameters["segments"]
	_thickness = _parameters["thickness"]
	_thickness_difference = _parameters["thickness difference"]
	
	_curve = Curve3D.new()
	
	var sum = Vector3(0.0, 0.0, 0.0)
	_curve.add_point(sum, Vector3(0.0, 0.0, 0.0), Vector3(0.0, _segments[1].length(), 0.0))

	for index in range(1, _segments.size() - 1):
		sum += _segments[index]
		_curve.add_point(sum, _segments[index - 1], _segments[index + 1])
	
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

func get_cap_direction():
	return _segments[-1] - _segments[-2]

func get_cap_origin():
	var result = Vector3(0.0, 0.0, 0.0)
	for segment in _segments:
		result += segment 
		
	return result

var _delta = 0.01

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, 0.0, 0.0)
	elif _parameter == 1.0:
		return _segments[-1]
	
	var global_parameter = _curve.point_count * _parameter
	
	var current_thickness = _thickness
	
	var current_sample = _curve.samplef(global_parameter)
	var delta_sample = _curve.samplef(global_parameter + _delta)
	var tangent = (delta_sample - current_sample)
	
	var axis = tangent.cross(Vector3(0.0, 1.0, 0.0)).normalized()
	var angle = tangent.signed_angle_to(Vector3(0.0, 1.0, 0.0), axis)
	var result = Vector3(cos(_angle), 0.0, sin(_angle)) * current_thickness
	result = result.rotated(axis, angle)
	return result + current_sample
	
	#var perpendicular = Vector3(cos(_angle), 0.0, sin(_angle))
	#perpendicular.y = (-tangent.x * perpendicular.x -tangent.z * perpendicular.z) / tangent.y
	#
	#perpendicular *= current_thickness / perpendicular.length()
	#
	#return current_sample + perpendicular

func get_face_direction():
	return true

func _get_precision():
	return 100

func _get_parameter_to_angle_precision_ratio():
	return 10.0
