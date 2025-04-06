extends GutTest

var distribution_of_distributions: DistributionOfDistributions

func before_each():
	var min_value = -13.0
	var max_value = 17.0
	var min_span = 1.0
	var max_span = 7.0
	
	distribution_of_distributions = DistributionOfDistributions.new(min_value, max_value, min_span, max_span)

func test_valid_distributions_and_spans():
	var sample_count = 100
	for i in range(0, sample_count):
		var sample_distribution = distribution_of_distributions.get_random_distribution()
		assert_true(sample_distribution is Distribution)
		assert_gte(sample_distribution.min_value, distribution_of_distributions.min_value)
		assert_lte(sample_distribution.max_value, distribution_of_distributions.max_value)
		assert_lt(sample_distribution.min_value, sample_distribution.max_value)
		
		var span = sample_distribution.max_value - sample_distribution.min_value
		assert_gte(span, distribution_of_distributions.min_span)
		assert_lte(span, distribution_of_distributions.max_span)

func test_seed_functionality():
	var seed = 0
	distribution_of_distributions.set_seed(seed)
	var first_run_values = []
	var second_run_values = []
	var third_run_values = []

	var sample_count = 100
	for i in range(0, sample_count):
		first_run_values.append(distribution_of_distributions.get_random_distribution().get_random_value())

	distribution_of_distributions.set_seed(seed)

	for i in range(0, sample_count):
		second_run_values.append(distribution_of_distributions.get_random_distribution().get_random_value())

	for i in range(0, sample_count):
		third_run_values.append(distribution_of_distributions.get_random_distribution().get_random_value())

	for i in range(0, sample_count):
		assert_eq(first_run_values[i], second_run_values[i], "The generated values should be the same for the same seed")
		assert_ne(first_run_values[i], third_run_values[i], "The generated values should be different for different seeds")

func test_expected_values_match():
	var sample_count = 100
	var total_middle_point = 0.0
	var total_span = 0.0

	for i in range(0, sample_count):
		var sample_distribution = distribution_of_distributions.get_random_distribution()
		var middle_point = (sample_distribution.max_value + sample_distribution.min_value) / 2
		total_middle_point += middle_point
		var span = sample_distribution.max_value - sample_distribution.min_value
		total_span += span

	var average_middle_point = total_middle_point / sample_count
	var expected_middle_point = (distribution_of_distributions.min_value + distribution_of_distributions.max_value) / 2
	assert_almost_eq(average_middle_point, expected_middle_point, 0.1)

	var average_span = total_span / sample_count
	assert_almost_eq(average_span, (distribution_of_distributions.min_span + distribution_of_distributions.max_span) / 2, 0.1)
