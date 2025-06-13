extends Node

var generated_species: Array[IngredientSpecies] = []

## Adds a new species to the registery
func add_species(species: IngredientSpecies = null):
	if species == null:
		species = GlobalFamiliesRandomizer.generate_random_species(GameState._game_seed + generated_species.size())
	
	generated_species.append(species)

## Deletes all the species from the registery
func clear_species():
	for species in generated_species:
		species.queue_free()
	
	generated_species = []

func _get_random_species(seed: int = 0) -> IngredientSpecies:
	if generated_species.size() == 0:
		push_error("No species in registry")
	
	var random = RandomNumberGenerator.new()
	if seed != 0:
		random.seed = seed
	
	return generated_species[random.randi_range(0, generated_species.size() - 1)]

var _queue := []
var _elements_ready := 0
var _next_ready := 0
const _all_spaces := 200
var _queue_mutex := Mutex.new()

var done = 0

func _shroom_producer():
	for i in range(_all_spaces):
		_queue.push_back(0)
	
	while generated_species.size() < 5:
		pass
	
	while done == 0:
		if _elements_ready < _all_spaces:
			var seed = randi()
			var shroom_to_add = _get_random_species(seed).generate_specimen(seed)
			
			_queue_mutex.lock()
			
			var next_empty = _next_ready + _elements_ready
			next_empty %= _all_spaces
			_queue[next_empty] = shroom_to_add
			_elements_ready += 1
			
			_queue_mutex.unlock()

var producer_thread := Thread.new()

func _ready():
	producer_thread.start(self._shroom_producer)

func _notification(what: int):
	if (what == NOTIFICATION_PREDELETE):
		done = 1

var _look_up_mutex := Mutex.new()

## Returns a random shroom
## If seed == 0 then it's all random, if seed != 0 then that seed will be used for the generation
func generate_shroom(seed: int = 0) -> IngredientSpecimen:
	var result
	
	while true:
		_look_up_mutex.lock()
		if _elements_ready > 0:
			break
		_look_up_mutex.unlock()
		
	_queue_mutex.lock()
	
	result = _queue[_next_ready]
	_next_ready += 1
	_next_ready %= _all_spaces
	_elements_ready -= 1
	
	_queue_mutex.unlock()
	
	_look_up_mutex.unlock()
	
	return result
