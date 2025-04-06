extends Node

class_name MaterialComponent

## A virtual function that generates a material based on the provided parameters and seed
## Note: Material may change due to the how oblivious to the material system the author is :(
func generate_material(_parameters: Dictionary, _seed: int) -> Material:
	return Material.new()
