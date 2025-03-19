## This class is a interface that describes one procedural generation model for shrooms. There are going to be many such models, all tied together in 
## [ INSERT THE CLASS NAME HERE ] so that they can be selected at random for every species of shrooms. [br]
## It is also able to generate a new distribution of parameters for a species according to a given seed.
class_name SpeciesShape

func generate_new_distribution(seed :int) -> void:
	assert(false, "This function needs to be overriden")

func generate_shroom(seed :int) -> MeshInstance3D:
	assert(false, "This function needs to be overriden")
	return
