extends Leg
class_name BezierLeg

var _height
var _bezier_points

func get_face_direction():
	return true

func _init(c_seed = null):
	var num_of_points = 5
	if c_seed != null:
		seed(c_seed)
	var height = 1.0 + 1.0 * randf()
	_bezier_points = [Vector3(0.0, 0.0, 0.0)]
	for i in range(num_of_points - 1):
		var new_point = Vector3(randf() - 0.5, height / num_of_points, randf() - 0.5) * i
		_bezier_points.push_back(new_point)
	
	_bezier_points.push_back(Vector3(0.0, height, 0.0))

func get_value_at(parameter :float, angle :float) -> Vector3:
	return _get_bezier(parameter, _bezier_points) + (Vector3(cos(angle), 0.0, sin(angle)) * 0.1)

func get_cap_direction():
	return (_bezier_points[-1] - _bezier_points[-2]).normalized()

func get_cap_origin():
	return _bezier_points[-1]
