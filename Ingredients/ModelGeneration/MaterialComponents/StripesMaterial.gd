extends MaterialComponent

class_name StripesMaterial

static func get_default() -> Dictionary:
	return {
		"base color red": 0.2,
		"base color green": 0.5,
		"base color blue": 0.55,
		"stripe color red": 0.95,
		"stripe color green": 0.93,
		"stripe color blue": 0.9,
		"number of stripes": 6,
		"blend": 2.0,
	}

static func get_default_distribution_of_distributions() -> Dictionary:
	return {
		"base color red": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"base color green": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"base color blue": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"stripe color red": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"stripe color green": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"stripe color blue": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"number of stripes": DistributionOfDistributions.new(2, 15, 0, 3),
		"blend": DistributionOfDistributions.new(0.2, 2.0, 0.1, 0.2),
	}

static func generate_material(_parameters: Dictionary, _seed: int) -> Material:
	var base_color = Color(_parameters["base color red"], _parameters["base color green"], _parameters["base color blue"])
	var stripe_color = Color(_parameters["stripe color red"], _parameters["stripe color green"], _parameters["stripe color blue"])
	var number_of_stripes = _parameters["number of stripes"]
	var blend = _parameters["blend"]
	
	var image = Image.create(texture_resolution, texture_resolution, false, Image.FORMAT_RGB8)
	for x in range(texture_resolution):
		for y in range(texture_resolution):
			var shroom_view =  Vector2(x, y) - Vector2(texture_resolution / 2.0, texture_resolution / 2.0)
			var angle = shroom_view.angle()
			var sin_value = sin(angle * number_of_stripes)
			var stripe_weigth = 0.5 + 0.5 * pow(abs(sin_value), blend) * sign(sin_value)
			image.set_pixel(x, y, stripe_color * stripe_weigth + base_color * (1.0 - stripe_weigth))
	
	var texture = ImageTexture.create_from_image(image)
	
	var result = StandardMaterial3D.new()
	result.albedo_texture = texture
	return result
