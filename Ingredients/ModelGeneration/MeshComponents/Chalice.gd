extends Cap

class_name Chalice

# https://www.desmos.com/calculator/ygkjrtkukt
# _height and _stipe_height can be pretty much whatever
var _height: float
var _stipe_height: float
# _radius >> _stipe_thickness
var _radius: float
var _stipe_thickness: float
# steepness, you should figure out what it should be, default is 1.5
var _steepness: float

const argument_height = "chalice mesh height"
const argument_stipe_height = "chalice mesh stipe height"
const argument_radius = "chalice mesh radius"
const argument_stipe_thickness = "chalice mesh stipe thickness"
const argument_steepness = "chalice mesh steepness"

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_height = _parameters[argument_height]
	_stipe_height = _parameters[argument_stipe_height]
	_radius = _parameters[argument_radius]
	_stipe_thickness = _parameters[argument_stipe_thickness]
	_steepness = _parameters[argument_steepness]
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

static func get_default() -> Dictionary:
	return {
		argument_height: 2.0,
		argument_stipe_height: 1.0,
		argument_radius: 4.0,
		argument_stipe_thickness: 1.0,
		argument_steepness: 1.5,
	}

static func get_default_distribution_of_distributions() -> Dictionary:
	return {
		argument_height: DistributionOfDistributions.new(2, 5, 0.1, 1),
		argument_stipe_height: DistributionOfDistributions.new(0.1, 3, 0.05, 0.5),
		argument_radius: DistributionOfDistributions.new(1, 3, 0.1, 1),
		argument_stipe_thickness: DistributionOfDistributions.new(0.05, 0.5, 0.05, 0.2),
		argument_steepness: DistributionOfDistributions.new(0.01, 2, 0.05, 0.2)
	}

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, _stipe_height, 0.0)
	elif _parameter == 1.0:
		#return Vector3(cos(_angle) *  _stipe_height, _stipe_thickness, sin(_angle) * _stipe_height)
		return Vector3(0.0, 0.0, 0.0)
	
	var effective_radius
	var effective_height
	if _parameter <= 1.0 / 2.0:
		effective_radius = 2 * _parameter * _radius
		effective_height = _stipe_height + (1 - cos(_parameter * 2 * PI)) / 2 * (_height - _stipe_height)
	else:
		effective_radius = _radius - (_parameter - 0.5) * 2 * (_radius - _stipe_thickness)
		effective_height = _height - _height * pow((2 * _parameter - 1), _steepness)
	
	return Vector3(cos(_angle) * effective_radius, effective_height, sin(_angle) * effective_radius)

func get_face_direction():
	return true

func _get_precision():
	return 8

func _get_parameter_to_angle_precision_ratio():
	return 1.0
