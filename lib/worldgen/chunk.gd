## Represents a single chunk of the world map.
##
## The game world is made up of cells grouped into chunks, which form a square grid.
##
## See: [WorldCell], [WorldGenParams].
class_name Chunk

## The side length of a chunk.
const SIZE := 32

var _cells: Array[WorldCell] = []

## Creates a chunk with all cells set to null.
func _init() -> void:
	_cells.resize(SIZE * SIZE)

## Returns the [WorldCell] stored at the given relative coordinates.
func get_cell(rel_coords: Vector2i) -> WorldCell:
	return _cells[rel_coords.y * SIZE + rel_coords.x]

## Replaces the [WorldCell] stored at the given relative coordinates with [param cell].
func set_cell(rel_coords: Vector2i, cell: WorldCell) -> void:
	_cells[rel_coords.y * SIZE + rel_coords.x] = cell

# Gaussian blur parameters and constants:
const _R := 3
const _SIDELEN := 2 * _R + 1
const _SD := 0.8
const _2SDSQ := 2.0 * _SD * _SD
static var _GAUSSIAN := PackedFloat64Array()

const _NOISE_COORD_COEFF := 2.0

static func _static_init() -> void:
	# Calculate the Gaussian blur matrix:
	_GAUSSIAN.resize(_SIDELEN * _SIDELEN)
	for xy in Util.vec2i_range(Vector2i(-_R, -_R), Vector2i(_R + 1, _R + 1)):
		var i := xy.y + _R
		var j := xy.x + _R
		_GAUSSIAN[i * _SIDELEN + j] = exp(-(xy.x * xy.x + xy.y * xy.y) / _2SDSQ) / (PI * _2SDSQ)

static func _gen_biomic(noise_gen: FastNoiseLite, coords: Vector2i) -> Vector2:
	var noise_xy := _NOISE_COORD_COEFF * coords
	var biomic_x := noise_gen.get_noise_3d(noise_xy.x, noise_xy.y, 0)
	var biomic_y := noise_gen.get_noise_3d(noise_xy.x, noise_xy.y, 100)
	var biomic_xy := Vector2(biomic_x, biomic_y)
	return biomic_xy

## Generates a copy of the chunk at the given super coordinates.
static func generate(gen_params: WorldGenParams, super_coords: Vector2i) -> Chunk:
	var noise_gen := FastNoiseLite.new()
	noise_gen.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise_gen.seed = gen_params.master_seed
	
	var white_gen := WhiteNoise.new()
	white_gen.seed = gen_params.master_seed
	
	var chunk := Chunk.new()
	var corner_coords := super_coords * SIZE
	
	# 1. Generate the biomic coordinates from noise
	
	for rel_coords in Util.vec2i_range(Vector2i(0, 0), Vector2i(SIZE, SIZE)):
		var biomic_xy := _gen_biomic(noise_gen, corner_coords + rel_coords)
		chunk.set_cell(rel_coords, WorldCell.new(biomic_xy))
	
	# 2. Make biome edges smoother using Gaussian blur
	
	for rel_coords in Util.vec2i_range(Vector2i(0, 0), Vector2i(SIZE, SIZE)):
		var blurred := Vector2(0, 0)
		for offset in Util.vec2i_range(Vector2i(-_R, -_R), Vector2i(_R + 1, _R + 1)):
			var i := offset.y + _R
			var j := offset.x + _R
			var xy := rel_coords + offset
			if xy.x < 0 or xy.y < 0 or xy.x >= SIZE or xy.y >= SIZE:
				blurred += _gen_biomic(noise_gen, corner_coords + xy) * _GAUSSIAN[i * _SIDELEN + j]
			else:
				blurred += chunk.get_cell(xy).biomic_xy * _GAUSSIAN[i * _SIDELEN + j]
		chunk.get_cell(rel_coords).biomic_xy = blurred
	
	# 3. Generate point-like structures

	var goblin_candidates: Array[Vector2i] = []

	for rel_coords in Util.vec2i_range(Vector2i(0, 0), Vector2i(SIZE, SIZE)):
		var coords := corner_coords + rel_coords
		var x = coords.x
		var y = coords.y
		var r_shroom := absf(white_gen.get_noise_3d(x, y, 100))
		var r_goblin := absf(white_gen.get_noise_3d(x, y, 200))
		var r_tree := absf(white_gen.get_noise_3d(x, y, 300))
		if r_shroom <= 0.005:
			chunk.get_cell(rel_coords).has_shroom = true
		if r_goblin <= gen_params.goblin_threshold:
			if gen_params.safe_zone_radius <= 0 or coords.length() > gen_params.safe_zone_radius:
				goblin_candidates.append(rel_coords)
		if r_tree <= 0.005:
			chunk.get_cell(rel_coords).has_tree = true

	# Filter goblins by minimum distance to prevent clustering
	var placed_goblins: Array[Vector2i] = []
	for candidate in goblin_candidates:
		var too_close := false
		if gen_params.min_enemy_distance > 0:
			for placed in placed_goblins:
				if (candidate - placed).length() < gen_params.min_enemy_distance:
					too_close = true
					break
		if not too_close:
			chunk.get_cell(candidate).has_goblin = true
			placed_goblins.append(candidate)
	
	# alternative method of generation:
	# (honestly idk if it doesn't yield better results...)
	#var rng := RandomNumberGenerator.new()
	#rng.seed = hash(noise_gen.seed) ^ hash(super_coords)
	#
	#for i in range(20):
	#	var x := rng.randi_range(0, SIZE - 1)
	#	var y := rng.randi_range(0, SIZE - 1)
	#	chunk.get_cell(Vector2i(x, y)).biomic_xy = Vector2(0, 0)
	
	return chunk
