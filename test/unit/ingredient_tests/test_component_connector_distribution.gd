extends GutTest

var distribution_spans = [
	{"dist1": Distribution.new(1, 7), "dist2": Distribution.new(6, 2)},
	{"dist1": Distribution.new(-10, 20), "dist2": Distribution.new(5, 15)},
	{"dist1": Distribution.new(-10, 100), "dist2": Distribution.new(50, 60)},
	{"dist1": Distribution.new(3, 8)},
	{"dist1": Distribution.new(2, 5), "dist2": Distribution.new(10, 15), "dist3": Distribution.new(20, 30)},
	{"dist1": Distribution.new(0, 100000), "dist2": Distribution.new(2, 20), "dist3": Distribution.new(3, 30), "dist4": Distribution.new(4, 40), "dist5": Distribution.new(5, 50), "dist6": Distribution.new(1000, 1001), "dist7": Distribution.new(-10, 540), "dist8": Distribution.new(-800, 20), "dist9": Distribution.new(-1, 1), "dist10": Distribution.new(10, 100)}
]

func test_generate_parameters():
	var distribution = ComponentConnectorDistribution.new()
	var parameters = distribution.generate_parameters(0)
	assert_not_null(parameters)
	assert_true(parameters is ComponentConnectorParameters, "Should return an instance of ComponentConnectorParameters")
	var param_dict = parameters.get_parameters()
	assert_eq(param_dict.size(), 0, "Generated parameters dictionary should be empty")

func test_add_distributions_to_dictionary():
	var component = ComponentConnectorDistribution.new()
	component.distribution_dictionary = {"dist1": Distribution.new(1, 7), "dist2": Distribution.new(6, 2)}
	assert_eq(component.distribution_dictionary.size(), 2, "Distribution dictionary should contain 2 items")
	assert_true("dist1" in component.distribution_dictionary, "'dist1' should be a key in the distribution dictionary")
	assert_true("dist2" in component.distribution_dictionary, "'dist2' should be a key in the distribution dictionary")

func test_generate_parameters_with_distribution():
	for distribution_dict in distribution_spans:
		var component = ComponentConnectorDistribution.new()
		component.distribution_dictionary = distribution_dict

		for i in range(100):
			var parameters = component.generate_parameters(i)
			var param_dict = parameters.get_parameters()
			
			assert_eq(param_dict.size(), distribution_dict.size(), "Generated parameters dictionary should contain " + str(distribution_dict.size()) + " items")
			if param_dict.size() == distribution_dict.size():
				for key in distribution_dict.keys():
					var dist = distribution_dict[key]
					assert_between(param_dict[key], dist.min, dist.max, key + " should be within the range " + str(dist.min) + " to " + str(dist.max))

func test_generated_parameters_are_different():
	var component = ComponentConnectorDistribution.new()
	component.distribution_dictionary = {"dist1": Distribution.new(1, 7), "dist2": Distribution.new(6, 2)}

	var previous_parameters = component.generate_parameters(0).get_parameters()

	for i in range(1, 10):
		var parameters = component.generate_parameters(i)
		var param_dict = parameters.get_parameters()
		
		assert_ne(param_dict, previous_parameters, "Generated parameters should be different for different seeds")
		previous_parameters = param_dict
