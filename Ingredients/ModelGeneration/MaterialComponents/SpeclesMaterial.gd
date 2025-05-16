extends MaterialComponent

class_name SpeclesMaterial

static func get_default() -> Dictionary:
	return {
		"base color red": 0.9,
		"base color green": 0.1,
		"base color blue": 0.05,
		"specle color red": 0.95,
		"specle color green": 0.93,
		"specle color blue": 0.9,
		"number of specles": 20,
		"min specle diameter": 0.05,
		"steepness": 1.1,
	}

static func get_default_distribution_of_distributions() -> Dictionary:
	return {
		"base color red": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"base color green": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"base color blue": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"specle color red": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"specle color green": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"specle color blue": DistributionOfDistributions.new(0.0, 1.0, 0.05, 0.1),
		"number of specles": DistributionOfDistributions.new(2, 20, 0, 5),
		"min specle diameter": DistributionOfDistributions.new(0.05, 0.4, 0.01, 0.05),
		"steepness": DistributionOfDistributions.new(1.1, 10.0, 0.1, 0.2),
	}

static func generate_material(_parameters: Dictionary, _seed: int) -> Material:
	var base_color: Color = Color(_parameters["base color red"], _parameters["base color green"], _parameters["base color blue"])
	var specle_color: Color = Color(_parameters["specle color red"], _parameters["specle color green"], _parameters["specle color blue"])
	var number_of_specles: int = _parameters["number of specles"]
	var min_specle_diameter: float = _parameters["min specle diameter"]
	#var max_specle_diameter: float = min_specle_diameter + _parameters["specle difference"]
	var max_specle_diameter: float = min_specle_diameter + 0.1
	var steepness: float = _parameters["steepness"]
	
	var main_texture = Image.create(texture_resolution, texture_resolution, false, Image.FORMAT_RGB8)
	main_texture.fill(base_color)
	
	var random = RandomNumberGenerator.new()
	random.set_seed(_seed)
	
	for specle in range(number_of_specles):
		var specle_radius: int = int(random.randf_range(min_specle_diameter, max_specle_diameter) / 2.0 * texture_resolution + 1)
		var specle_position = Vector2i(Vector2(random.randf_range(0.0, 1.0), random.randf_range(0.0, 1.0)) * texture_resolution)
		
		for y in range(-specle_radius, specle_radius):
			var absolute_y = specle_position.y + y
			if absolute_y < 0 or absolute_y > texture_resolution:
				continue
			
			if absolute_y >= texture_resolution:
				absolute_y = 0
			
			var width = sqrt(specle_radius * specle_radius - y * y) + 1
			for x in range(-width, width):
				var absolute_x = specle_position.x + x
				
				if absolute_x >= texture_resolution:
					absolute_x = 0
				
				if absolute_x < 0 or absolute_x > texture_resolution:
					continue
				
				var radius = sqrt(x * x + y * y)
				var weight = pow(steepness - pow(radius / float(specle_radius), 2.0), 0.2)
				main_texture.set_pixel(absolute_x, absolute_y, main_texture.get_pixel(absolute_x, absolute_y) * (1.0 - weight) + specle_color * weight)
	
	var texture = ImageTexture.create_from_image(main_texture)
	
	var result = StandardMaterial3D.new()
	result.albedo_texture = texture
	return result
