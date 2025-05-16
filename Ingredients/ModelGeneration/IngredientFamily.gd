extends Node
class_name IngredientFamily

## This method should be overridden in the inheriting class
func generate_species(seed: int) -> IngredientSpecies:
	return IngredientSpecies.new()

## This method should be overridden in the inheriting class
func get_probability_weight() -> float:
	assert(false, "Override this method")
	return 0

func generate_model(distributions: Dictionary, _seed: int) -> MeshInstance3D:
	assert(false, "Override this method")
	return MeshInstance3D.new()
