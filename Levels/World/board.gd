class_name Board

var gen_params := WorldGenParams.new()
var _chunks: Dictionary[Vector2i, Chunk] = {}

func get_chunk(super_coords: Vector2i) -> Chunk:
	var chunk := _chunks.get(super_coords) as Chunk
	if chunk == null:
		chunk = Chunk.generate(gen_params, super_coords)
		_chunks[super_coords] = chunk
	return chunk


func has_chunk(super_coords: Vector2i) -> bool:
	return _chunks.has(super_coords)
