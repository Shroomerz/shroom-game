class_name World
extends Node2D

@onready var _tiles := $Tiles
@onready var _player := $PlayerCharacter
@onready var _camera := $PlayerCharacter/Camera
@onready var _items_layer := $ItemsLayer
@onready var _enemies_layer := $EnemiesLayer
@onready var _regen_area := $RegenArea
@onready var _regen_area_shape := $RegenArea/Shape
@onready var _tile_size: int = $Tiles.tile_set.tile_size.x * $"Tiles".scale.x
@onready var _tile_scale_factor: int = $Tiles.scale.x
var _threads: Array[Thread] = []
var timer := 5.0

func _init() -> void:
	# Resetting/initializing GameState here is not a good idea.
	# This is temporary, just to get it to run, as currently no one else
	# is initializing it, and World needs a Board to work on.
	# If you are reading this and want to do this GameState initialization etc
	# elsewhere, please do feel free to remove this code.
	var game_seed := randi()
	print("Setting game seed = ", game_seed)
	GameState.reset(game_seed)
	GameState.next_day()

func _ready() -> void:
	for i in range(1, 10):
		GlobalSpeciesRegistry.add_species()
	_regen_area_shape.scale = Vector2(Chunk.SIZE, Chunk.SIZE)
	_regen_area.position = Vector2(0.5, 0.5) * Chunk.SIZE * _tile_size
	_populate_chunks_around(Vector2i(0, 0))

func _process(delta_: float) -> void:
	# Collect the threads that have finished their work:
	#var threads_to_remove: Array[int] = []
	#for i in range(_threads.size()):
	#	print("threadus ", _threads[i], " maximus")
	#	if !_threads[i].is_alive():
	#		print("Thread ", _threads[i].get_id(), " is done, calling wait_to_finish()")
	#		_threads[i].wait_to_finish()
	#		threads_to_remove.append(i)
	#threads_to_remove.reverse()
	#for idx in threads_to_remove:
	#	_threads.remove_at(idx)
	pass

func _physics_process(delta: float) -> void:
	GameState.set_player_pos(_player.global_position)

func _on_regen_area_body_exited(body: Node2D) -> void:
	if get_tree().paused:
		return
	if body == _player:
		var super_coords := _player.get_super_coords() as Vector2i
		_regen_area.position = (Vector2(super_coords) + Vector2(0.5, 0.5)) * Chunk.SIZE * _tile_size
		var populating_thread := Thread.new()
		print("DUPA AAAAAAAAAA")
		populating_thread.start(_populate_chunks_around.bind(super_coords))
		print("DUPA BBBBBBBBBBBB")
		_threads.append(populating_thread)
		print("DUPA CCCCCCCCCC")
		print("new _threads = ", _threads)

func _exit_tree() -> void:
	print("We have ", _threads.size(), " threads")
	for thread in _threads:
		print("Waiting on ", thread.get_id())
		thread.wait_to_finish()
		print("Waiting done")
	print("World._exit_tree() done.")

func _populate_chunks_around(super_coords: Vector2i) -> void:
	for offset in Util.vec2i_range(Vector2i(-1, -1), Vector2i(2, 2)):
		_populate_chunk_at(super_coords + offset)
	print("_populate_chunks_around(...) done")

func _populate_chunk_at(super_coords: Vector2i) -> void:
	if GameState.get_board().has_chunk(super_coords):
		# It's already populated, don't waste time filling the same tiles in again
		return
	var chunk := GameState.get_board().get_chunk(super_coords)
	var corner_coords := super_coords * Chunk.SIZE
	for dy in range(Chunk.SIZE):
		for dx in range(Chunk.SIZE):
			var rel_coords := Vector2i(dx, dy)
			var coords := corner_coords + rel_coords
			var cell := chunk.get_cell(rel_coords)
			var tile_coords := _tile_scale_factor * Vector2i(2.0 * (cell.biomic_xy.clampf(-0.999, 0.999) + Vector2(1, 1)))
			tile_coords += Vector2i(rel_coords.x % _tile_scale_factor, rel_coords.y % _tile_scale_factor)
			if cell.has_shroom:
				var shroom = GlobalSpeciesRegistry.generate_shroom()
				#var shroom = ExampleShroom.new()
				var shroom_scene = preload("res://Levels/World/shroom_entity.tscn").instantiate()
				shroom_scene.setup(shroom, _on_shroom_pickup.bind(shroom_scene))
				shroom_scene.position = coords * _tile_size
				_items_layer.call_thread_safe("add_child", shroom_scene)
			if cell.has_goblin:
				var enemy_scene = preload("res://enemies/enemy/Enemy.tscn").instantiate()
				enemy_scene.position = coords * _tile_size
				_enemies_layer.call_thread_safe("add_child", enemy_scene)
			if cell.has_tree:
				_tiles.call_thread_safe("set_cell", coords, 1, Vector2i(0, 2))
			else:
				_tiles.call_thread_safe("set_cell", coords, 0, tile_coords)

func _on_shroom_pickup(body: Node2D, shroom_scene) -> void:
	#print("bbbbbbbbbbbbbbbbbbbbbbbbbbb ", shroom_scene, " and ", body)
	if body == _player:
		#print("duuuuuuuupaaaa")
		
		shroom_scene._subviewport.remove_child(shroom_scene.shroom)
		GameState.get_inventory().add_item(shroom_scene.shroom, 1)
		_items_layer.remove_child.call_deferred(shroom_scene)

func _place_item(position: Vector2, item: Item) -> void:
	var item_entity = item.create_world_entity()
	item_entity.position = position
	_items_layer.add_child(item_entity)
