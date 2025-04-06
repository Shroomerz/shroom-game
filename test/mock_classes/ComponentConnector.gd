extends Node
class_name ComponentConnector

## This method should be overridden in the inheriting class
func generate_model(parameters: ComponentConnectorParameters, seed: int) -> MeshInstance3D:
	return MeshInstance3D.new()
