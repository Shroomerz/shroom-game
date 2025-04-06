extends Node

class_name Distribution

var min_value: float
var max_value: float

func _init(min_value: float, max_value: float):
	self.min_value = min_value
	self.max_value = max_value

func get_random_value() -> float:
	return -10000.0

func set_seed(seed):
	pass
