extends Stipe

class_name BezierStipe

var _length: float
var _thickness: float
var _max_incline: float
var _number_of_segments: int

var _vector_sub_sums: Array
var _segment_length: float

const argument_segment_length = "bezier stipe mesh segment length"
const argument_thickness = "bezier stipe mesh thickness"
const argument_max_incline = "bezier stipe mesh max incline"
const argument_number_of_segments = "bezier stipe mesh number of segments"

func _next_segment(random: RandomNumberGenerator) -> Vector3:
	var incline = random.randf_range(0.0, _max_incline * PI / 2.0)
	var rotation = random.randf_range(0.0, 2.0 * PI)
	
	var segment_height = cos(incline) * _segment_length
	var plane_radius = sin(incline) * _segment_length
	return Vector3(cos(rotation) * plane_radius, segment_height, sin(rotation) * plane_radius)

static func get_default() -> Dictionary:
	return {
		argument_segment_length: 0.5,
		argument_thickness: 0.3,
		argument_max_incline: 0.3,
		argument_number_of_segments: 3,
	}

static func get_default_distribution_of_distributions() -> Dictionary:
	return {
		argument_segment_length: DistributionOfDistributions.new(0.2, 0.7, 0.1, 0.4),
		argument_thickness: DistributionOfDistributions.new(0.05, 0.8, 0.05, 0.24),
		argument_max_incline: DistributionOfDistributions.new(0.0, 1.0, 0.1, 0.11),
		argument_number_of_segments: DistributionOfDistributions.new(2.0, 6.0, 1.0, 3.0),
	}

func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	_vector_sub_sums = [Vector3(0.0, 0.0, 0.0)]
	
	_segment_length = _parameters[argument_segment_length]
	_thickness = _parameters[argument_thickness]
	_max_incline = _parameters[argument_max_incline]
	_number_of_segments = _parameters[argument_number_of_segments]
	
	_length = _segment_length * _number_of_segments * 3
	
	var random = RandomNumberGenerator.new()
	random.set_seed(_seed)
	
	_vector_sub_sums.append(_next_segment(random))
	_vector_sub_sums.append(_vector_sub_sums[-1] + _next_segment(random))
	_vector_sub_sums.append(_vector_sub_sums[-1] + _next_segment(random))
	
	for segment in range(_number_of_segments - 1):
		_vector_sub_sums.append(2.0 * _vector_sub_sums[-1] - _vector_sub_sums[-2])
		_vector_sub_sums.append(_vector_sub_sums[-1] + _next_segment(random))
		_vector_sub_sums.append(_vector_sub_sums[-1] + _next_segment(random))
	
	var array_mesh = get_mesh()
	var result = MeshInstance3D.new()
	result.mesh = array_mesh
	return result

func get_cap_direction():
	return (_vector_sub_sums[-1] - _vector_sub_sums[-2]) * 0.5 + Vector3(0.0, 1.0, 0.0) * 0.5
	#return Vector3(1.0, 1.0, 1.0)
	
func get_cap_origin():
	return _vector_sub_sums[-1]

func _get_segments(_parameter: float) -> Array:
	var segment = floor((_number_of_segments * _parameter)) * 3
	var result = _vector_sub_sums.slice(segment, segment + 4)
	result.append(fmod(_number_of_segments * _parameter, 1.0))
	
	return result

func get_value_at(_parameter :float, _angle :float) -> Vector3:
	if _parameter == 0.0:
		return Vector3(0.0, 0.0, 0.0)
	elif _parameter == 1.0:
		return _vector_sub_sums[-1]
	
	var sub_curve = _get_segments(_parameter)
	
	var point: Vector3 = sub_curve[0]
	var derivative: Vector3 = point.bezier_derivative(sub_curve[1], sub_curve[2], sub_curve[3], sub_curve[4]).normalized()
	point = point.bezier_interpolate(sub_curve[1], sub_curve[2], sub_curve[3], sub_curve[4])
	
	var first_perpendicular = Vector3(0.1, -derivative.x * 0.1 / derivative.y, 0.0).normalized()
	var second_perpendicular = Vector3(0.0, -derivative.z * 0.1 / derivative.y, 0.1).normalized()
	
	#var first_perpendicular = Vector3(1.0, 0.0, 0.0)
	#var second_perpendicular = Vector3(0.0, 0.0, 1.0)
	
	return (first_perpendicular * cos(_angle) + second_perpendicular * sin(_angle)) * _thickness + point

func get_face_direction():
	return false

func _get_precision():
	#return _number_of_segments * 2
	return 8

func _get_parameter_to_angle_precision_ratio():
	return _number_of_segments * 2.0
