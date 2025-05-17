extends IngredientFamily

class_name ChaliceFamily

func get_probability_weight() -> float:
	return 0.1

# Dictionary structure:
# material: 
#    reference: [reference to material]
#    parameters:
#       [a dictionary of pairs "[parameter name]": [Distribution object]
# mesh:
#    [a dictionary of pairs "[parameter name]": [Distribution object]

func generate_species(seed: int) -> IngredientSpecies:
	var result = IngredientSpecies.new(seed)
	
	var random = RandomNumberGenerator.new()
	random.set_seed(seed)
	
	
	# TODO: Materials should be picked at random from a list which is initiated at startup
	var material;
	if random.randf() < 0.5:
		material = SpeclesMaterial.new()
	else:
		material = StripesMaterial.new()
	
	result.parameters_dictionary["material"] = \
		{"reference": material, \
		"parameters": DistributionOfDistributions.randomize_over_dictionary(material.get_default_distribution_of_distributions(), seed)}
	result.parameters_dictionary["mesh"] = DistributionOfDistributions.randomize_over_dictionary(Chalice.get_default_distribution_of_distributions(), seed)
	
	result.family = self
	
	return result

func generate_model(parameters_dictionary: Dictionary, _seed: int) -> Array[MeshInstance3D]:
	var material_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["material"]["parameters"], _seed)
	var mesh_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["mesh"], _seed)
	
	var chalice_generator = Chalice.new()
	var result = chalice_generator.generate_mesh(mesh_parameters, _seed)
	result.material_override = parameters_dictionary["material"]["reference"].generate_material(material_parameters, _seed)
	
	return [result]
