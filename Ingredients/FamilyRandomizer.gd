extends Node

class_name FamilyRandomizer

var families: Array = []
var _total_weight: float = 0
const families_path: String = "res://Ingredients/ModelGeneration/Families/"

func _init():
	#var directory = DirAccess.open(families_path)
	#if directory == null:
		#push_error("The path to SpeciesFamilies is incorrect")
	#
	#directory.list_dir_begin()
	#var family_path = directory.get_next()
	#while family_path != "":
		#if !family_path.ends_with(".gd"):
			#family_path = directory.get_next()
			#continue
		#var family_script = load(families_path.path_join(family_path))
		#add_family(family_script.new())
		#family_path = directory.get_next()
	
	# Sometimes you try do things the "right" way... and then it comes back to bite you in the bottom :>
	add_family(ChaliceFamily.new())
	add_family(CapNStipeFamily.new())

func add_family(family: IngredientFamily):
	families.append(family)
	_total_weight += family.get_probability_weight()

func generate_random_species(seed: int) -> IngredientSpecies:
	var random_value = randf() * _total_weight
	for family in families:
		random_value -= family.get_probability_weight()
		if random_value <= 0:
			return family.generate_species(seed)
	
	# Fallback in case of rounding errors
	return families[0].generate_species(seed)
