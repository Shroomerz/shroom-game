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
var attack_speed:float = 1.0

var hamski_hack_prosze_tego_psia_krew_nie_tykac_bo_zamorduje = 0

func take_damage(damage: float):
	health -= damage

func apply_damage_change(change: int):
	damage += change
	if damage < 1:
		damage = 1

func apply_attack_speed_change(change: float):
	attack_speed += change
	if attack_speed > 2:
		attack_speed = 2
	if attack_speed < 0.5:
		attack_speed = 0.5
		
func apply_speed_change(change: float):
	speed += change
	if speed < 0.5:
		speed = 0.5

func apply_max_health_change(change: float):
	max_health += change
	if health > max_health:
		take_damage(health - max_health)

func give_points(change_in_points: int):
	points += change_in_points

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
