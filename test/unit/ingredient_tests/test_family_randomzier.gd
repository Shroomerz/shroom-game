extends GutTest

var randomizer: FamilyRandomizer

func before_all():
	randomizer = FamilyRandomizer.new()
	# Add mock families with different weights
	randomizer.add_family(MockFamily.new(1.0))
	randomizer.add_family(MockFamily.new(2.0))
	randomizer.add_family(MockFamily.new(3.0))

func test_generate_random_species():
	var species = randomizer.generate_random_species(0)
	assert_not_null(species, "Generated species should not be null")
	assert_true(species is IngredientSpecies, "Should return an instance of IngredientSpecies")

func test_family_selection_probability():
	var selection_counts = {
		"family1": 0,
		"family2": 0,
		"family3": 0
	}
	var total_iterations = 1000
	
	for i in range(total_iterations):
		var species = randomizer.generate_random_species(i)

		# Compare the resultant distribution's max_value to differentiate between families
		if species.distribution.max_value == 10:
			selection_counts["family1"] += 1
		elif species.distribution.max_value == 20:
			selection_counts["family2"] += 1
		elif species.distribution.max_value == 30:
			selection_counts["family3"] += 1
	
	var total_weight = 6.0
	var expected_family1_probability = 1.0 / total_weight
	var expected_family2_probability = 2.0 / total_weight
	var expected_family3_probability = 3.0 / total_weight
	
	var tolerance = 0.05
	assert_almost_eq(selection_counts["family1"] / total_iterations, expected_family1_probability, tolerance, "Family 1 selection probability is out of expected range")
	assert_almost_eq(selection_counts["family2"] / total_iterations, expected_family2_probability, tolerance, "Family 2 selection probability is out of expected range")
	assert_almost_eq(selection_counts["family3"] / total_iterations, expected_family3_probability, tolerance, "Family 3 selection probability is out of expected range")

class MockFamily extends IngredientFamily:
	var weight: float

	func _init(weight: float):
		self.weight = weight

	func generate_species(seed: int) -> IngredientSpecies:
		var species = IngredientSpecies.new()
		species.distribution = Distribution.new(0, weight * 10)
		return species

	func get_probability_weight() -> float:
		return weight
