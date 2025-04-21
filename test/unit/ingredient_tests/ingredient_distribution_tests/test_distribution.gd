extends GutTest

var distribution: Distribution

func before_each():
	var min_value = -3.0
	var max_value = 3.0
	distribution = Distribution.new(min_value, max_value)

func test_returns_float():
	var value = distribution.get_random_value()
	assert_true(value is float)

# Test to ensure the mean of the distribution is approximately correct
func test_distribution_mean():
	var average = 0.0
	var sample_count = 100
	for i in range(0, sample_count):
		average += distribution.get_random_value() / sample_count

	var expected_mean = (distribution.get_min() + distribution.get_max()) / 2
	assert_almost_eq(average, expected_mean, 0.1)

# Test to ensure the generated values are within the specified range
func test_value_within_range():
	var sample_count = 100
	for i in range(0, sample_count):
		var value = distribution.get_random_value()
		assert_between(value, distribution.get_min(), distribution.get_max())

# Test to ensure the generated values are different
func test_generated_values_are_different():
	var sample_count = 100
	var values = []
	
	for i in range(0, sample_count):
		values.append(distribution.get_random_value())

	for i in range(0, sample_count):
		assert_eq(values.find(values[i], i + 1), -1)

func test_set_seed():
	for i in range(1, 1000, 10):
		distribution.set_seed(i)
		var first_result = distribution.get_random_value()
		var second_result = distribution.get_random_value()
		distribution.set_seed(i)
		var first_result_repicked = distribution.get_random_value()
		
		assert_eq(first_result, first_result_repicked)
		assert_ne(first_result, second_result)
