extends IngredientFamily

class_name CapNStipeFamily

func get_probability_weight() -> float:
	return 0.1

# Dictionary structure:
# "cap material": 
#    "reference": [reference to the cap's material]
#    "parameters":
#       [a dictionary of pairs "[parameter name]": [Distribution object]
# "cap mesh":
#    "reference": [reference to the cap's mesh]
#    "parameters"
#       [a dictionary of pairs "[parameter name]": [Distribution object]
# "stipe material": 
#    "reference": [reference to the stipe's material]
#    "parameters":
#       [a dictionary of pairs "[parameter name]": [Distribution object]
# "stipe mesh":
#    "reference": [reference to the stipe's mesh]
#    "parameters"
#       [a dictionary of pairs "[parameter name]": [Distribution object]

func generate_species(seed: int) -> IngredientSpecies:
	var result = IngredientSpecies.new(seed)
	
	var random = RandomNumberGenerator.new()
	random.set_seed(seed)
	
	
	# TODO: Materials should be picked at random from a list which is initiated at startup
	var cap_material;
	if random.randf() < 0.5:
		cap_material = SpeclesMaterial.new()
	else:
		cap_material = StripesMaterial.new()
		
	var stipe_material;
	if random.randf() < 0.5:
		stipe_material = SpeclesMaterial.new()
	else:
		stipe_material = StripesMaterial.new()
	
	# TODO: Caps should be picked at random from a list which is initiated at startup
	
	var cap_mesh;
	if random.randf() < 0.5:
		cap_mesh = ExponentialCap.new()
	else:
		cap_mesh = FlatCap.new()
	
	var stipe_mesh;
	if random.randf() < 0.5:
		stipe_mesh = BezierStipe.new()
	else:
		stipe_mesh = StraightStipe.new()
	
	result.parameters_dictionary["cap material"] = {
		"reference": cap_material,
		"parameters": DistributionOfDistributions.randomize_over_dictionary(cap_material.get_default_distribution_of_distributions(), seed)
	}
	result.parameters_dictionary["cap mesh"] = {
		"reference": cap_mesh,
		"parameters": DistributionOfDistributions.randomize_over_dictionary(cap_mesh.get_default_distribution_of_distributions(), seed + 100)
	}
	result.parameters_dictionary["stipe material"] = {
		"reference": stipe_material,
		"parameters": DistributionOfDistributions.randomize_over_dictionary(stipe_material.get_default_distribution_of_distributions(), seed + 200)
	}
	result.parameters_dictionary["stipe mesh"] = {
		"reference": stipe_mesh,
		"parameters": DistributionOfDistributions.randomize_over_dictionary(stipe_mesh.get_default_distribution_of_distributions(), seed + 300)
	}
	
	result.family = self
	
	return result

func generate_model(parameters_dictionary: Dictionary, _seed: int) -> Array[MeshInstance3D]:
	var cap_material_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["cap material"]["parameters"], _seed)
	var cap_mesh_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["cap mesh"]["parameters"], _seed)
	var stipe_material_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["stipe material"]["parameters"], _seed + 1)
	var stipe_mesh_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["stipe mesh"]["parameters"], _seed + 1)
	
	var result: Array[MeshInstance3D] = []
	result.append(parameters_dictionary["cap mesh"]["reference"].generate_mesh(cap_mesh_parameters, _seed))
	result[0].material_overlay = parameters_dictionary["cap material"]["reference"].generate_material(cap_material_parameters, _seed)
	result.append(parameters_dictionary["stipe mesh"]["reference"].generate_mesh(stipe_mesh_parameters, _seed + 1))
	result[1].material_overlay = parameters_dictionary["stipe material"]["reference"].generate_material(stipe_material_parameters, _seed + 1)
	
	result[0].position = parameters_dictionary["stipe mesh"]["reference"].get_cap_origin()
	
	var stipe_direction = parameters_dictionary["stipe mesh"]["reference"].get_cap_direction()
	var rotation_axis = Vector3(0.0, 1.0, 0.0).cross(stipe_direction).normalized()
	var angle = Vector3(0.0, 1.0, 0.0).signed_angle_to(stipe_direction, rotation_axis)
	if rotation_axis.length_squared() != 0:
		result[0].rotate(rotation_axis, angle)
	
	return result
