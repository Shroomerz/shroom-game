class_name ParametricSolid

## * parameter in [0, 1]
## 		NOTE: Please specify the function for parameter = 0. That point is going to be the origin of the mesh
## * angle in [0, 2π]
func get_value_at(parameter :float, angle :float) -> Vector3:
	assert(false, "This is a virtual function, it may not be invoked directly")
	return Vector3(0.0, 0.0, 0.0)

## This function can be overriden to change the default direction of faces
func get_face_direction():
	return false

func _get_x(radius :float, angle :float):
	return radius * cos(angle)

func _get_y(radius :float, angle :float):
	return radius * sin(angle)

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

var precision = 10
func set_precision(c_precision :int):
	precision = c_precision

## Some shapes need grater angular precision while other require higher radial precision. Overriding this function
## you can change the ratio of one to the other
func _get_parameter_to_angle_precision_ratio():
	return 1.0

## A function that renders a parametrically defined solid to a mesh. The mesh must be defined as a function from
## a circle in polar coordinates (namely, from [0, 1] x [0, 2π) ), to R^3. See [annotation ParametricSolid][br][br]
##
## Arguments: [br]
## * solid ~ a parametrically defined solid[br]
## * parameter_precision[br]
## * angle_precision ~ the two aforementioned arguments describe the precision with which the domain is sampled,
## they represent the number of segments into which each axis is divided into.
func get_mesh():
	var angle_precision = max(int(2 * precision / (1 + _get_parameter_to_angle_precision_ratio())), 3)
	var parameter_precision = 2 * precision - angle_precision
	assert(parameter_precision > 2, "Parameter_precision to low, try changing the ratio or increasing the precision")
	
	var angle_increment = 2.0 * PI / float(angle_precision)
	var parameter_increment = 1.0 / float(parameter_precision)
	
	var surface_constructor = SurfaceTool.new()
	surface_constructor.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Creating the array of verticies, later we connect them using their indicies
	surface_constructor.add_vertex(get_value_at(0.0, 0))
	
	var angle_iterator = 0
	var parameter_iterator = 1
	while parameter_iterator < parameter_precision:
		angle_iterator = 0
		while angle_iterator < angle_precision:
			surface_constructor.add_vertex(get_value_at(parameter_iterator * parameter_increment, angle_iterator * angle_increment))
			angle_iterator += 1
		parameter_iterator += 1

	surface_constructor.add_vertex(get_value_at(1.0, 0.0))
		
	# Now the whole array of verticies is finished, we wish to connect the verticies using their indicies
	
	angle_iterator = 0
	while angle_iterator < angle_precision:
		if (get_face_direction()):
			surface_constructor.add_index(0)
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, 1, angle_iterator))
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, 1, angle_iterator + 1))
		else:
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, 1, angle_iterator))
			surface_constructor.add_index(0)
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, 1, angle_iterator + 1))
		
		angle_iterator += 1
	
	parameter_iterator = 1
	while parameter_iterator < parameter_precision - 1:
		angle_iterator = 0
		while angle_iterator < angle_precision:
			if (get_face_direction()):
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator + 1))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator))
				
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator + 1))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator + 1))
			else:
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator + 1))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator))
				
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator + 1))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator + 1, angle_iterator))
				surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_iterator, angle_iterator + 1))

				
			angle_iterator += 1
		parameter_iterator += 1
		
	angle_iterator = 0
	while angle_iterator < angle_precision:
		if (get_face_direction()):
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision - 1, angle_iterator))
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision, 0))
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision - 1, angle_iterator + 1))
		else:
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision, 0))
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision - 1, angle_iterator))
			surface_constructor.add_index(_get_vertex_at(parameter_precision, angle_precision, parameter_precision - 1, angle_iterator + 1))
			
		angle_iterator += 1
		
	surface_constructor.generate_normals()
	return surface_constructor.commit()

static func _get_vertex_at(parameter_precision :int, angle_precision :int, parameter_index :int, angle_index :int):
	if (parameter_index == 0):
		return 0
	
	return (parameter_index - 1) * angle_precision + 1 + angle_index % angle_precision
