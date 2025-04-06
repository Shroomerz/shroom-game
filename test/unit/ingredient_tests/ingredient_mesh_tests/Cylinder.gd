extends ParametricSolid

var height = 1.0
var radius = 0.5

func get_value_at(parameter :float, angle :float) -> Vector3:
	if parameter == 0:
		return Vector3(0.0, height / 2.0, 0.0)
	elif parameter < 0.25:
		parameter *= 4.0
		return Vector3(parameter * cos(angle) * radius, height / 2.0, parameter * sin(angle) * radius)
	elif parameter < 0.75:
		parameter -= 0.25
		parameter *= 2.0
		return Vector3(radius * cos(angle), height / 2.0 - parameter * height, radius * sin(angle))
	parameter -= 0.75
	parameter *= 4.0
	return Vector3((1.0 - parameter) * radius * cos(angle), -height / 2.0, (1.0 - parameter) * radius * sin(angle))
