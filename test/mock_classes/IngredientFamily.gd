extends Node
class_name IngredientFamily

## This method should be overridden in the inheriting class
func generate_species(seed: int) -> IngredientSpecies:
	return IngredientSpecies.new()

## This method should be overridden in the inheriting class
func get_probability_weight() -> float:
	return -18.0
