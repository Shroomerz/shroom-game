## A class for rendering a parametrically defined solid to a mesh. Don't instantiate it.
class_name ParametricCylindricallMesher

static func _new():
	assert(false, "No se puede instanciar esta clase directamente")
	return null  #

## A function that renders a parametrically defined solid to a mesh
## * curve ~ a parametrically defined solid
## * parameter_precision ~ the sample rate of the curve. NOTE: if you want to render a detail of length x\
## the parameter_precision ought to be at least x / 2 (optimally ~x / 5)
## * angle_precision ~ samples are going to be taken at TODO: finish this documentation
static func get_mesh(curve :ParametricSolid, parameter_precision :float = 0.01, angle_precision :int = 100):
	var angle_increment = 2.0 * PI / float(angle_precision)
	
	var surface_constructor = SurfaceTool.new()
	surface_constructor.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var zero_vertex = curve.get_value_at(0.0, 0)
	var angle_iterator = 0
	while angle_iterator < angle_precision:
		surface_constructor.add_vertex(zero_vertex)
		surface_constructor.add_vertex(curve.get_value_at(parameter_precision, angle_iterator * angle_increment))
		surface_constructor.add_vertex(curve.get_value_at(parameter_precision, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
		angle_iterator += 1
	
	var last_parameter_iterator = 0.0
	var parameter_iterator = parameter_precision
	while parameter_iterator < 1.0:
		angle_iterator = 0
		while angle_iterator < angle_precision:
			surface_constructor.add_vertex(curve.get_value_at(last_parameter_iterator, angle_iterator * angle_increment))
			surface_constructor.add_vertex(curve.get_value_at(parameter_iterator, angle_iterator * angle_increment))
			surface_constructor.add_vertex(curve.get_value_at(parameter_iterator, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
			
			surface_constructor.add_vertex(curve.get_value_at(last_parameter_iterator, angle_iterator * angle_increment))
			surface_constructor.add_vertex(curve.get_value_at(parameter_iterator, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
			surface_constructor.add_vertex(curve.get_value_at(last_parameter_iterator, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
			angle_iterator += 1
			
		last_parameter_iterator = parameter_iterator
		parameter_iterator += parameter_precision
		
	parameter_iterator = 1.0
	angle_iterator = 0
	while angle_iterator < angle_precision:
		surface_constructor.add_vertex(curve.get_value_at(last_parameter_iterator, angle_iterator * angle_increment))
		surface_constructor.add_vertex(curve.get_value_at(parameter_iterator, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
		surface_constructor.add_vertex(curve.get_value_at(last_parameter_iterator, fmod((angle_iterator + 1) * angle_increment, 2 * PI)))
		angle_iterator += 1
		
	surface_constructor.generate_normals()
	return surface_constructor.commit()
