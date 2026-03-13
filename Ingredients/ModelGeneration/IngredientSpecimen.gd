extends Item
class_name IngredientSpecimen

var alchemy_stats
var new_x

const box_size = 10

func _init():
	var i = GameState.get_next_specimen_id()
	itemID = "Shroom" + str(i)
	new_x = i * box_size

	usable = true
	type = "3d"

	var camera = Camera3D.new()
	camera.current = true
	camera.position = Vector3(new_x, 2.5, 5.0)

	var environment = Environment.new()
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.8, 0.6, 1.0)
	environment.ambient_light_energy = 1.0
	camera.environment = environment
	add_child(camera)

	var light = OmniLight3D.new()
	light.position = Vector3(new_x - box_size / 4, box_size, box_size / 2)
	light.omni_range = 1.5 * box_size
	light.omni_attenuation = -0.5
	add_child(light)

func create_inventory_entity():
	var result = Node.new()
	for child in get_children():
		result.add_child(child.duplicate())
	return result

func use():
	AlchemyStats.apply_stats(alchemy_stats)
