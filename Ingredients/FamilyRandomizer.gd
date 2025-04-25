extends Node
class_name FamilyRandomizer

var families: Array = []
var _total_weight: float = 0

func add_family(family: IngredientFamily):
	families.append(family)
	_total_weight += family.get_probability_weight()

func generate_random_species(seed: int) -> IngredientSpecies:
	var random_value = randf() * _total_weight
	for family in families:
		random_value -= family.get_probability_weight()
		if random_value <= 0:
			return family.generate_species(seed)
	
	# Fallback in case of rounding errors
	return families[0].generate_species(seed)
