extends Item
class_name IngredientSpecimen

var alchemy_stats
var new_x

func _init():
	# To jest brzydkie, ale nie ma już czasu zrobić tego sensownie
	itemID = "Shroom" + str(GameState.hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje)
	var i = GameState.hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje
	new_x = i * 10
	
	usable = true
	type = "3d"
	
	var camera = Camera3D.new()
	camera.current = true
	camera.position = Vector3(new_x, 2.0, 6.0)
	
	if i == 0:
		var light = DirectionalLight3D.new()
		light.rotate_x(0.7)
		add_child(light)
	
	add_child(camera)
	
	GameState.hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje += 1

func use():
	AlchemyStats.apply_stats(alchemy_stats)
