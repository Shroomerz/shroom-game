extends Node

class_name DistributionOfDistributions

var min_value: float
var max_value: float
var min_span: float
var max_span: float

func _init(min_value: float, max_value: float, min_span: float, max_span: float):
	self.min_value = min_value
	self.max_value = max_value
	self.min_span = min_span
	self.max_span = max_span

func get_random_distribution() -> Distribution:
	return Distribution.new(0, 0)

func set_seed(seed: int):
	pass
