extends Node

class_name Distribution

var _mean: float
var _deviation: float
var _min_value: float
var _max_value: float
var _randomizer: RandomNumberGenerator

func _init(min_value: float, max_value: float, seed: int = 1):
	set_min_max(min_value, max_value)
	_randomizer = RandomNumberGenerator.new()
	set_seed(seed)

func set_seed(seed: int):
	_randomizer.set_seed(seed)

func set_min_max(min_value: float, max_value: float):
	_min_value = min_value
	_max_value = max_value
	_update_min_max()

func _update_min_max():
	_deviation = (_max_value - _min_value) / 6
	_mean = (_min_value + _max_value) / 2

func get_min():
	return _min_value

func get_max():
	return _max_value

func get_random_value() -> float:
	var result = _mean - 4 * _deviation
	
	while result < _min_value or result > _max_value:
		result = _randomizer.randfn(_mean, _deviation)
	
	return result

static func randomize_over_dictionary(dictionary: Dictionary, seed: int) -> Dictionary:
	var result = {}
	var i = 0
	for key in dictionary.keys():
		dictionary[key].set_seed(i + seed)
		result[key] = dictionary[key].get_random_value()
		i += 1
	
	return result
