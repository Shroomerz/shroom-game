## A class for rendering a parametrically defined solid to a mesh. Don't instantiate it.
class_name ParametricPolarMesher

static func _new():
	assert(false, "This class may not be instantiated")
	return null

## A function that renders a parametrically defined solid to a mesh. The mesh must be defined as a function from
## a circle in polar coordinates (namely, from [0, 1] x [0, 2π) ), to R^3. See [annotation ParametricSolid][br][br]
##
## Arguments: [br]
## * solid ~ a parametrically defined solid[br]
## * parameter_precision[br]
## * angle_precision ~ the two aforementioned arguments describe the precision with which the domain is sampled,
## they represent the number of segments into which each axis is divided into.
static func get_mesh(solid :ParametricSolid, parameter_precision :int = 30, angle_precision :int = 30):
	var angle_increment = 2.0 * PI / float(angle_precision)
	var parameter_increment = 1.0 / float(parameter_precision)
	
	var surface_constructor = SurfaceTool.new()
	surface_constructor.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Creating the array of verticies, later we connect them using their indicies
	surface_constructor.add_vertex(solid.get_value_at(0.0, 0))
	
	var angle_iterator = 0
	var parameter_iterator = 1
	while parameter_iterator < parameter_precision:
		angle_iterator = 0
		while angle_iterator < angle_precision:
			surface_constructor.add_vertex(solid.get_value_at(parameter_iterator * parameter_increment, angle_iterator * angle_increment))
			angle_iterator += 1
		parameter_iterator += 1

	surface_constructor.add_vertex(solid.get_value_at(1.0, 0.0))
		
	# Now the whole array of verticies is finished, we wish to connect the verticies using their indicies
	
	angle_iterator = 0
	while angle_iterator < angle_precision:
		if (solid.get_face_direction()):
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
			if (solid.get_face_direction()):
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
		if (solid.get_face_direction()):
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
