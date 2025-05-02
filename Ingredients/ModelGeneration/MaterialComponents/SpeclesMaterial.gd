extends MaterialComponent

class_name SpeclesMaterial

static func generate_material(_parameters: Dictionary, _seed: int) -> Material:
	var base_color: Color = _parameters["base color"]
	var specle_color: Color = _parameters["specle color"]
	var number_of_specles: int = _parameters["number of specles"]
	var max_specle_diameter: float = _parameters["max specle diameter"]
	var min_specle_diameter: float = _parameters["min specle diameter"]
	var steepness: float = _parameters["steepness"]
	
	var main_texture = Image.create(texture_resolution, texture_resolution, false, Image.FORMAT_RGB8)
	main_texture.fill(base_color)
	
	var random = RandomNumberGenerator.new()
	random.set_seed(_seed)
	
	for specle in range(number_of_specles):
		var specle_radius: int = random.randf_range(min_specle_diameter, max_specle_diameter) / 2.0 * texture_resolution + 1
		var specle_position = Vector2i(Vector2(random.randf_range(0.0, 1.0), random.randf_range(0.0, 1.0)) * texture_resolution)
		
		for y in range(-specle_radius, specle_radius):
			var absolute_y = specle_position.y + y
			if absolute_y < 0 or absolute_y > texture_resolution:
				continue
			
			var width = sqrt(specle_radius * specle_radius - y * y) + 1
			for x in range(-width, width):
				var absolute_x = specle_position.x + x
				if absolute_x < 0 or absolute_x > texture_resolution:
					continue
				
				var radius = sqrt(x * x + y * y)
				var weight = pow(1.1- pow(radius / float(specle_radius), 2.0), 0.2)
				print(main_texture.get_pixel(absolute_x, absolute_y))
				main_texture.set_pixel(absolute_x, absolute_y, main_texture.get_pixel(absolute_x, absolute_y) * (1.0 - weight) + specle_color * weight)
	
	var texture = ImageTexture.create_from_image(main_texture)
	
	var result = StandardMaterial3D.new()
	result.albedo_texture = texture
	return result
