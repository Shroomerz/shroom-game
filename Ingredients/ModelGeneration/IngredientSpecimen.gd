extends Item
class_name IngredientSpecimen

var alchemy_stats

func _init():
	usable = true
	type = "3d"
	
	var camera = Camera3D.new()
	camera.current = true
	camera.position = Vector3(0.0, 2.0, 6.0)
	var light = DirectionalLight3D.new()
	light.rotate_x(0.7)
	
	add_child(camera)
	add_child(light)
	
	itemID = "Shroom"

func use():
	AlchemyStats.apply_stats(alchemy_stats)
