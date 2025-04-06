extends Node
class_name FamilyRandomizer

var families: Array = []

func add_family(family: IngredientFamily):
	families.append(family)

func generate_random_species(seed: int) -> IngredientSpecies:
	var total_weight = 0.0
	for family in families:
		total_weight += family.get_probability_weight()
	
	var random_value = randf() * total_weight
	for family in families:
		random_value -= family.get_probability_weight()
		if random_value <= 0:
			return family.generate_species(seed)
	
	# Fallback in case of rounding errors
	return families[0].generate_species(seed)
