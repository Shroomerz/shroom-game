extends ParametricSolid
class_name FunnyCap

func get_value_at(parameter :float, angle :float):
	var radius
	var height
	if (parameter <= 0.5):
		radius = 0.689202 * parameter * 2.0
		height = -1.4*(radius * radius - 0.7)
	else:
		radius = 0.689202 - 0.689202 * (parameter - 0.5) * 2.0
		height = -0.6*(radius * radius - 1.0)
	
	return Vector3(get_x(radius, angle), height, get_y(radius, angle))
