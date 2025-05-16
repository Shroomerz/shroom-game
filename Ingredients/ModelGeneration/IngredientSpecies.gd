extends Node
class_name IngredientSpecies

var family: IngredientFamily = null
var parameters_dictionary = {}

func generate_specimen(seed: int) -> IngredientSpecimen:
	# TODO implement alchemy system here
	var specimen = IngredientSpecimen.new()
	var models = family.generate_model(parameters_dictionary, seed)
	for i in range(models.size()):
		models[i].name = "model " + str(i)
		specimen.add_child(models[i])
	return specimen
