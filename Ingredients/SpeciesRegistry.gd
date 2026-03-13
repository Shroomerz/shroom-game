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
var _semaphore := Semaphore.new()

var _done := false

func _shroom_producer():
	for i in range(_all_spaces):
		_queue.push_back(null)

	while generated_species.size() < 5:
		if _done:
			return
		OS.delay_msec(10)

	while not _done:
		_queue_mutex.lock()
		var count = _elements_ready
		_queue_mutex.unlock()

		if count < _all_spaces:
			var s = randi()
			var shroom_to_add = _get_random_species(s).generate_specimen(s)

			_queue_mutex.lock()
			var next_empty = (_next_ready + _elements_ready) % _all_spaces
			_queue[next_empty] = shroom_to_add
			_elements_ready += 1
			_queue_mutex.unlock()

			_semaphore.post()
		else:
			OS.delay_msec(1)

var producer_thread := Thread.new()

func _ready():
	producer_thread.start(self._shroom_producer)

func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		_done = true
		if producer_thread.is_started():
			producer_thread.wait_to_finish()

## Returns a random shroom from the pre-generated queue
func generate_shroom(_seed: int = 0) -> IngredientSpecimen:
	_semaphore.wait()

	_queue_mutex.lock()
	var result = _queue[_next_ready]
	_next_ready = (_next_ready + 1) % _all_spaces
	_elements_ready -= 1
	_queue_mutex.unlock()

	return result
