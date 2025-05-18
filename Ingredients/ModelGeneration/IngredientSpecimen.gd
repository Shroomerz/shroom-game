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

	itemID = "Kategoria :) " + str(GameState.hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje)
	GameState.hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje += 1

func use():
	AlchemyStats.apply_stats(alchemy_stats)
