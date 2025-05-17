extends IngredientSpecimen

class_name ExampleShroom

func _init():
	var camera = Camera3D.new()
	camera.current = true
	camera.position = Vector3(0.0, 0.0, 3.0)
	var light = DirectionalLight3D.new()
	light.rotate_x(0.7)
	var cylinder = CSGCylinder3D.new()
	
	add_child(camera)
	add_child(light)
	add_child(cylinder)
