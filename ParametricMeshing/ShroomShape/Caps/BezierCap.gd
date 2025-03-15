extends Cap
class_name BezierCap

func _init(c_seed = null):
	if (c_seed != null):
		seed(c_seed)
	
	_bezier_points = [Vector2(0.0, 0.0), Vector2(0.1, 0.0), Vector2(-0.1, -0.1), Vector2(0.7, -0.3), Vector2(0.7, -0.6), Vector2(0.8, -0.7), Vector2(0.4, -1.0)]

func get_value_at(parameter :float, angle :float):
	if (parameter == 0.0):
		return Vector3(0.0, _bezier_points.back().y, 0.0)
	var cap_point_rotational = _get_bezier(parameter)
	return Vector3(cap_point_rotational.x * cos(angle), cap_point_rotational.y, cap_point_rotational.x * sin(angle))

func get_cap_origin():
	return _bezier_points[-1];
