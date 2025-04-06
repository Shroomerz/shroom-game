extends GutTest
class_name ComponentConnectorGenericTests

var connector_script_path
var connector

var tested_seeds = [1623, 1526, 72346, 213678, 26378356854, 12612, 342, 63427, 232423, 4223]
var performance_test_seed_count = 3
var performance_test_seeds = []

func before_all():
	var script = load(connector_script_path)
	connector = script.new()
	performance_test_seeds = tested_seeds.slice(0, performance_test_seed_count)

## This function should be overridden when writing a test for a realization of the ComponentConnector interface
func get_default_parameters() -> ComponentConnectorParameters:
	return ComponentConnectorParameters.new()

func test_generate_model():
	var parameters = get_default_parameters()
	for seed in tested_seeds:
		var model = connector.generate_model(parameters, seed)
		assert_not_null(model)
		assert_true(model is MeshInstance3D, "Should return an instance of MeshInstance3D")

	fail_test("Put here code that compares two meshes and decides if they are different or not")

func test_performance():
	var parameters = get_default_parameters()
	for seed in performance_test_seeds:
		var start_time = Time.get_ticks_msec()
		connector.generate_model(parameters, seed)
		var end_time = Time.get_ticks_msec()
		var elapsed_time = end_time - start_time
		assert_lt(elapsed_time, 100, "Model generation took too long for seed %d: %s ms" % [seed, elapsed_time])
