extends GutTest
class_name IngredientFamilyGenericTests

var family_script_path
var family

func before_all():
	var script = load(family_script_path)
	family = script.new()

func test_generate_species():
	for seed in range(101):
		var species = family.generate_species(seed)
		assert_not_null(species)
		assert_not_null(species.component_connector)
		assert_true(species is IngredientSpecies, "Should return an instance of IngredientSpecies")

func test_species_are_identical():
	for seed in range(101):
		var species1 = family.generate_species(seed)
		var species2 = family.generate_species(seed)
		var species3 = family.generate_species(seed + 1)

		assert_not_null(species1, "Generated species may not be empty")
		assert_not_null(species2, "Generated species may not be empty")
		assert_not_null(species3, "Generated species may not be empty")
		if (species1 == null or species2 == null or species3 == null):
			continue

		var distribution1 = species1.distribution
		var distribution2 = species2.distribution
		var distribution3 = species3.distribution

		if (distribution1 != null && distribution2 != null && distribution3 != null):
			assert_eq(distribution1.min_value, distribution2.min_value)
			assert_eq(distribution1.max_value, distribution2.max_value)
			
			assert_ne(distribution1.min_value, distribution3.min_value)
			assert_ne(distribution1.max_value, distribution3.max_value)

func test_get_probability_weight():
	var weight = family.get_probability_weight()
	assert_true(weight > 0, "Probability weight should be greater than 0")
