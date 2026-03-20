## Holds all the tweakable parameters used in the world generation process.
##
## See: [Chunk].
class_name WorldGenParams

var master_seed: int
var goblin_threshold: float = 0.0005
var min_enemy_distance: int = 0
var safe_zone_radius: int = 0

func _to_string() -> String:
	return "{master_seed={0}}".format([master_seed])
