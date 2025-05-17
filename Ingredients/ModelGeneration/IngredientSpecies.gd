extends Node
class_name IngredientSpecies

var family: IngredientFamily = null
var parameters_dictionary = {}
var alchemy_distribution

func _init(seed: int):
	alchemy_distribution = DistributionOfDistributions.randomize_over_dictionary(AlchemyStats.get_distribution_of_distributions(), seed)

func generate_specimen(seed: int) -> IngredientSpecimen:
	var specimen = IngredientSpecimen.new()
	var models = family.generate_model(parameters_dictionary, seed)
	for i in range(models.size()):
		models[i].name = "model " + str(i)
		specimen.add_child(models[i])
	
	specimen.alchemy_stats = Distribution.randomize_over_dictionary(alchemy_distribution, seed)
	
	var description = ""
	for pair in AlchemyStats.stats_to_strings(specimen.alchemy_stats):
		description += pair[0] + " = " + pair[1] + "\n"
	
	specimen.description = description
	
	return specimen
