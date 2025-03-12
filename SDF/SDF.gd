@icon("res://SDF/sdf_icon.png")
## A class for defining implicit surfaces and further rendering to a mesh in the `CubeMarcher`
## To use this class, inherit it and provide implementations for the required functions
class_name SDF
extends Node

## Returns the distance to the implicit surface, 
## you need to overwrite this function for the class to work properly
func get_value_at(input_position :Vector3) -> float:
	assert(false, "Error: \"get_value_at(input_position :Vector3)\" must be overwritten by an inheriting class. Overwrite this function with your own signed distance function.")
	return 1.0
	
## Returns the most negative corner of the box bounding the implicit surface, 
## you need to overwrite this function for the class to work properly
func get_negative_bound() -> Vector3:
	assert(false, "Error: \"get_negative_bound()\" must be overwritten by an inheriting class. Overwrite this function with your own signed distance function.")
	return Vector3(0.0, 0.0, 0.0)
	
## Returns the most positive corner of the box bounding the implicit surface, 
## you need to overwrite this function for the class to work properly
func get_positive_bound() -> Vector3:
	assert(false, "Error: \"get_positive_bound()\" must be overwritten by an inheriting class. Overwrite this function with your own signed distance function.")
	return Vector3(0.0, 0.0, 0.0)
	
## Determines the treshold of what constitues the implicit surface. 
## If the value of the signed distance function is smaller then the treshold at any given point, 
## then that point is inside the solid 
func get_treshold() -> float:
	return 0.001
	
## The small increment for finding the gradient of the sdf for determing the normal at any given point
var _normal_epsilon = 0.001

## Determines the normal to the surface at any given point.
## NOTE: It should be well defined for points relatively far away from the implicit surface 0.2 - 0.3
## TODO: Implement interpolation so that the normals are taken closer to the surface
func get_normal_at(input_point :Vector3) -> Vector3:
	var value_at_input_point = get_value_at(input_point)
	return Vector3(
		(get_value_at(input_point + Vector3(_normal_epsilon, 0.0, 0.0)) - value_at_input_point) / _normal_epsilon,
		(get_value_at(input_point + Vector3(0.0, _normal_epsilon, 0.0)) - value_at_input_point) / _normal_epsilon,
		( get_value_at(input_point + Vector3(0.0, 0.0, _normal_epsilon)) - value_at_input_point) / _normal_epsilon
	)


##SMOOTH BLENDING
func smoothBlend(d1, d2, k) -> float :
	var h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
	return lerp(d2, d1, h) - k * h * (1.0 - h);
