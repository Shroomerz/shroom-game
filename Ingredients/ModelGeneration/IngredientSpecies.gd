extends Node
class_name IngredientSpecies

var family: IngredientFamily = null
var parameters_dictionary = {}

func generate_specimen(seed: int) -> IngredientSpecimen:
	# TODO implement alchemy system here
	var specimen = IngredientSpecimen.new()
	var model = family.generate_model(parameters_dictionary, seed)
	model.name = "model"
	specimen.add_child(model)
	return specimen
