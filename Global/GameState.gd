## Holds the global state of a game.
extends Node

var _day_counter := 0
var _game_seed := 0
var _board: Board = null
var _inventory:Inventory = Inventory.new()

##player stats
var speed:float = 1.0
var damage:float = 10
var health:float = 100
var max_health:float = 100
var points:int = 0
var attack_speed:float = 2.0

func take_damage(damage: float):
	health -= damage

func apply_max_health_change(change: float):
	max_health -= change
	if health > max_health:
		take_damage(health - max_health)

func give_points(points: int):
	points += points

func reset(game_seed: int) -> void:
	_day_counter = 0
	_game_seed = game_seed
	_board = null

func _next_day_board() -> void:
	var gen_params = WorldGenParams.new()
	gen_params.master_seed = _game_seed ^ Util.hash_int(_day_counter)
	_board = Board.new()
	_board.gen_params = gen_params

func next_day() -> void:
	_day_counter += 1
	# Prepare the game state for the next day here.
	_next_day_board()

func get_day() -> int:
	return _day_counter

func get_board() -> Board:
	return _board

func get_inventory():
	return _inventory

func get_species_registry():
	# TODO: SpeciesRegistry class
	pass

# Savefiles -- TBD:

func save_data(slot, data):
	# TODO: savefiles
	pass

func load_data(slot):
	# TODO: savefiles
	pass
