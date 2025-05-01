class_name ParametricSolid

## This is the main function to ovveride. It is the parametric function which image from  [0, 1] x [0, 2π)
## gets written to the resultant mesh [br]
## * parameter in [0, 1] [br]
## * angle in [0, 2π) [br]
## [br]
## Underscores so that Godot doesn't whine about these variables beging unused
func get_value_at(_parameter :float, _angle :float) -> Vector3:
	assert(false, "This is a virtual function, it may not be invoked directly")
	return Vector3(0.0, 0.0, 0.0)

## This function can be overriden to change the default direction of faces [br]
## * Set false when you generate a model from the bottom up and [br]
## * true when you generate from the top down.
func get_face_direction():
	return false

func _get_precision():
	return 20

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
func get_mesh() -> ArrayMesh:
	var precision = _get_precision()
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
