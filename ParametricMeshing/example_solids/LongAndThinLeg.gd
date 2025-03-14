extends ParametricSolid
class_name LongAndThinLeg

var _height
var _bezier_points

func _init(c_seed = null):
	var num_of_points = 5
	if c_seed != null:
		seed(c_seed)
	var height = 1.0 + 3.0 * randf()
	_bezier_points = [Vector3(0.0, 0.0, 0.0)]
	for i in range(num_of_points - 1):
		var new_point = Vector3(randf() - 0.5, height / num_of_points, randf() - 0.5) * i
		_bezier_points.push_back(new_point)
	
	_bezier_points.push_back(Vector3(0.0, height, 0.0))

func get_value_at(parameter :float, angle :float) -> Vector3:
	
	var _bezier_buffer = _bezier_points
	while (typeof(_bezier_buffer) == typeof(_bezier_points) and _bezier_buffer.size() > 1):
		var _next_bezier_buffer = []
		var _bezier_buffer_iterator = 0
		while (_bezier_buffer_iterator < _bezier_buffer.size() - 1):
			_next_bezier_buffer.push_back(parameter * _bezier_buffer[_bezier_buffer_iterator] + (1 - parameter) * _bezier_buffer[_bezier_buffer_iterator + 1])
			_bezier_buffer_iterator += 1
		
		_bezier_buffer = _next_bezier_buffer
		
	
	return _bezier_buffer[0] + (Vector3(cos(angle), 0.0, sin(angle)) * 0.05)
