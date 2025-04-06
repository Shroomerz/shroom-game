extends Node

class_name MaterialComponent

## A virtual function that generates a material based on the provided parameters and seed [br]
## NOTE: The Material class return type might be different, someone has to read up on how this stuff works
func generate_material(parameters: Dictionary, seed: int) -> Material:
	return Material.new()
