extends MaterialComponent

class_name StripesMaterial

static func generate_material(_parameters: Dictionary, _seed: int) -> Material:
	var base_color = _parameters["base color"]
	var stripe_color = _parameters["stripe color"]
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
