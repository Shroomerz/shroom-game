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
	# TODO: add more materials
	var result = IngredientSpecies.new()
	result.parameters_dictionary["material"] = \
		{"reference": SpeclesMaterial.new(), \
		"parameters": DistributionOfDistributions.randomize_over_dictionary(SpeclesMaterial.get_default_distribution_of_distributions(), seed)}
	result.parameters_dictionary["mesh"] = DistributionOfDistributions.randomize_over_dictionary(Chalice.get_default_distribution_of_distributions(), seed)
	
	result.family = self
	
	return result

func generate_model(parameters_dictionary: Dictionary, _seed: int) -> MeshInstance3D:
	var material_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["material"]["parameters"], _seed)
	var mesh_parameters = Distribution.randomize_over_dictionary(parameters_dictionary["mesh"], _seed)
	
	var result = MeshInstance3D.new()
	var chalice_generator = Chalice.new()
	result.mesh = chalice_generator.generate_mesh(mesh_parameters, _seed).mesh
	result.material_override = parameters_dictionary["material"]["reference"].generate_material(material_parameters, _seed)
	
	return result
