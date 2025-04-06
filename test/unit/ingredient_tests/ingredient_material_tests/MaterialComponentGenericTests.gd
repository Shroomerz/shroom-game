extends GutTest
class_name MaterialComponentGenericTests

var component_script_path
var component

var tested_seeds = [1623, 1526, 72346, 213678, 26378356854, 12612, 342, 63427, 232423, 4223]
var performance_test_seed_count = 3
var performance_test_seeds = []

func before_all():
	var script = load(component_script_path)
	component = script.new()
	performance_test_seeds = tested_seeds.slice(0, performance_test_seed_count)

## This function should be overridden when writing a test for a realization of the MaterialComponent interface
func get_default_parameters() -> Dictionary:
	return {}

func test_material_properties_exist():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var material_instance = component.generate_material(parameters, seed)

		# TODO: put here some code that checks the is non empty
		fail_test("Decide what materials should actually be")

func test_materials_are_identical():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var material1 = component.generate_material(parameters, seed)
		var material2 = component.generate_material(parameters, seed)
		var material3 = component.generate_material(parameters, seed + 1)
		
		# TODO: put here some code that checks if the materials are the same
		fail_test("Decide what materials should actually be")

func test_performance():
	var parameters = get_default_parameters()
	for seed in performance_test_seeds:
		var start_time = Time.get_ticks_msec()
		component.generate_material(parameters, seed)
		var end_time = Time.get_ticks_msec()
		var elapsed_time = end_time - start_time
		assert_lt(elapsed_time, 100, "Material generation took too long for seed %d: %s ms" % [seed, elapsed_time])
