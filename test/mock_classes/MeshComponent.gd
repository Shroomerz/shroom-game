#Should inherit from Item
extends Node

class_name MeshComponent

## Virtual function that returns a parametrized mesh of the component
## Underscores so that Godot doesn't whine about these variables being unused
func generate_mesh(_parameters: Dictionary, _seed: int) -> MeshInstance3D:
	return MeshInstance3D.new()
