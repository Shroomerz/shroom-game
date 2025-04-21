extends Node

class_name DistributionOfDistributions

var _min_value: float
var _max_value: float
var _min_span: float
var _max_span: float
var _randomizer: RandomNumberGenerator

func _init(f_min_value: float, f_max_value: float, f_min_span: float, f_max_span: float):
	_randomizer = RandomNumberGenerator.new()
	set_range(f_min_value, f_max_value, f_min_span, f_max_span)

func set_range(f_min_value: float, f_max_value: float, f_min_span: float, f_max_span: float):
	assert(f_min_value < f_max_value)
	assert(f_min_span < f_max_span)
	assert(f_max_value - f_min_value > f_max_span)
	_min_value = f_min_value
	_max_value = f_max_value
	_min_span = f_min_span
	_max_span = f_max_span

func get_random_distribution() -> Distribution:
	var half_span = _randomizer.randf_range(_min_span, _max_span) / 2
	var mean = _randomizer.randf_range(_min_value + half_span, _max_value - half_span)
	return Distribution.new(mean - half_span, mean + half_span)

func get_min_value():
	return _min_value

func get_max_value():
	return _max_value

func get_min_span():
	return _min_span

func get_max_span():
	return _max_span

func set_seed(seed: int):
	_randomizer.seed = seed

func get_seed():
	return _randomizer.seed
