extends Stipe

class_name SimplePhysicsStipe

var points
func stiffness(force :float, bend :float):
	return force * (0.3 - bend)

func get_face_direction():
	return true

func _init():
	points = [
		Vector3(0.0, 0.0, 0.0),
		Vector3(0.05, 0.2, 0.3),
		Vector3(0.1, 0.4, 0.0),
		Vector3(0.15, 0.6, -0.5),
		Vector3(0.1, 0.8, 0.1),
		Vector3(-0.1, 1.0, 0.2),
	]
	
	var max_iterations = 100
	var iteration = 0
	
	while iteration < max_iterations:
		var force = Vector3(0.0, -1.0, 0.0)
		var rotation_angles = []
		var rotation_axes = []
		
		var arr_element = 2
		while arr_element < points.size():
			var direction_to_mass = points.back() - points[arr_element - 1]
			var torque = direction_to_mass.cross(force)
			
			var current_bend = (points[arr_element] - points[arr_element - 1]).angle_to(points[arr_element - 1] - points[arr_element - 2])
			
			rotation_angles.push_back(stiffness(torque.length(), current_bend))
			rotation_axes.push_back(torque.normalized())
			
			arr_element += 1
		
		var rotation_element = 0
		while rotation_element < rotation_angles.size():
			arr_element = rotation_element + 2
			while arr_element < points.size():
				points[arr_element] -= points[rotation_element + 1]
				points[arr_element] = points[arr_element].rotated(rotation_axes[rotation_element], rotation_angles[rotation_element])
				points[arr_element] += points[rotation_element + 1]
				arr_element += 1
			rotation_element += 1
		
		iteration += 1

func get_value_at(parameter :float, angle :float) -> Vector3:
	if parameter == 0.0:
		return points.front()
	elif parameter == 1.0:
		return points.back()
	
	var increment = 1.0 / (points.size() - 1)
	var segment = floor(parameter / increment)
	var point = points[segment].lerp(points[segment + 1], parameter - segment * increment)
	
	return point + 0.01 * Vector3(1.0, 0.0, 1.0).rotated(Vector3(0.0, 1.0, 0.0), angle)
