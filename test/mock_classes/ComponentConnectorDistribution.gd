extends Node

class_name ComponentConnectorDistribution

var distribution_dictionary :Dictionary

func generate_parameters(seed: int) -> ComponentConnectorParameters:
	return ComponentConnectorParameters.new()
