class_name ParametricSolid

## * parameter in [0, 1]
## 		NOTE: Please specify the function for parameter = 0. That point is going to be the origin of the mesh
## * angle in [0, 2π]
func get_value_at(parameter :float, angle :float) -> Vector3:
	assert(false, "This is a virtual function, it may not be invoked directly")
	return Vector3(0.0, 0.0, 0.0)

func get_face_direction():
	return false

func _get_x(radius :float, angle :float):
	return radius * cos(angle)

func _get_y(radius :float, angle :float):
	return radius * sin(angle)

# Miscellaneous functions

## Retruns a point at the Bezier curve. The dimensionality of the output depends on the 
## type of points in the input
static func _get_bezier(parameter :float, bezier_points :Array):
	var _bezier_buffer = bezier_points
	# "typeof"s are here because an Array that has one element is no array anymore (I guees...)
	while (typeof(_bezier_buffer) == typeof(bezier_points) and _bezier_buffer.size() > 1):
		var _next_bezier_buffer = []
		var _bezier_buffer_iterator = 0
		while (_bezier_buffer_iterator < _bezier_buffer.size() - 1):
			_next_bezier_buffer.push_back(parameter * _bezier_buffer[_bezier_buffer_iterator] + (1 - parameter) * _bezier_buffer[_bezier_buffer_iterator + 1])
			_bezier_buffer_iterator += 1
		
		_bezier_buffer = _next_bezier_buffer
	
	return _bezier_buffer[0]
