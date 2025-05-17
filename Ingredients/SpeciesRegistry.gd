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

func _get_random_species(seed: int) -> IngredientSpecies:
	if generated_species.size() == 0:
		push_error("No species in registry")
	
	var random = RandomNumberGenerator.new()
	random.seed = seed
	
	return generated_species[random.randi_range(0, generated_species.size() - 1)]

## Returns a random shroom
## If seed == 0 then it's all random, if seed != 0 then that seed will be used for the generation
func generate_shroom(seed: int = 0) -> IngredientSpecimen:
	var random = RandomNumberGenerator.new()
	
	if seed != 0:
		random.seed = seed
	
	var species_id = random.randi_range(0, generated_species.size() - 1)
	return generated_species[species_id].generate_specimen(random.randi())
