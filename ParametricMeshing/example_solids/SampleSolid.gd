extends ParametricSolid
class_name SampleSolid

func get_value_at(parameter :float, angle :float):
	var percent_of_rotation = angle / 2 / PI
	var radius = sin(2 * PI * parameter) * sin(2 * PI * parameter) + sin(PI * parameter) * ((percent_of_rotation) * (1 - percent_of_rotation) * 2.0 / 3.0 + 0.5)
	var height = cos(PI * parameter)
	return Vector3(radius * cos(angle), height, radius * sin(angle))
