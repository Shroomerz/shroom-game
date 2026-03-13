## Holds the global state of a game.
extends Node

signal overdosed
signal acidity_changed
signal stamina_changed

var _day_counter := 0
var _game_seed := 0
var _board: Board = null
var _inventory:Inventory = Inventory.new()

##player stats
var speed:float = 1.0
var damage:int = 10
var health:float = 100
var max_health:float = 100
var points:int = 0
var attack_speed:float = 1.0
var acidity:float = 0.0
const max_acidity = 100.0

var stamina:float = 100.0
var max_stamina:float = 100.0
const STAMINA_SPRINT_DRAIN := 12.0  # per second while sprinting
const STAMINA_ATTACK_COST := 25.0   # per attack (stepwise)
const STAMINA_REGEN_RATE := 8.0     # per second while idle/walking (inverse of sprint)

var player_pos: Vector2 = Vector2.ZERO

var _next_specimen_id: int = 0

func get_next_specimen_id() -> int:
	var id = _next_specimen_id
	_next_specimen_id += 1
	return id

func drain_stamina_sprint(delta: float) -> bool:
	if stamina <= 0:
		return false
	stamina = maxf(stamina - STAMINA_SPRINT_DRAIN * delta, 0.0)
	stamina_changed.emit()
	return true

func drain_stamina_attack() -> bool:
	if stamina < STAMINA_ATTACK_COST:
		return false
	stamina -= STAMINA_ATTACK_COST
	stamina_changed.emit()
	return true

func regen_stamina(delta: float) -> void:
	if stamina >= max_stamina:
		return
	stamina = minf(stamina + STAMINA_REGEN_RATE * delta, max_stamina)
	stamina_changed.emit()

func apply_acidity(change: float):
	acidity += change
	
	acidity_changed.emit(acidity)
	
	if acidity >= max_acidity:
		overdosed.emit()

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
	if points == 42:
		print("The answer to life, the universe, and everything.")
	elif points == 2137:
		print("O tej godzinie to nie powinno się grać.")

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

func hard_reset():
	speed = 1.0
	damage = 10
	health = 100
	max_health = 100
	points = 0
	attack_speed = 1.0
	acidity = 0;
	acidity_changed.emit(acidity)
	stamina = 100.0
	max_stamina = 100.0
	stamina_changed.emit()
	_inventory.clear()
	_next_specimen_id = 0
	#_day_counter = 0
	#_game_seed = 0
	
func get_day() -> int:
	return _day_counter

func get_board() -> Board:
	return _board

func get_inventory():
	return _inventory

func get_species_registry():
	return GlobalSpeciesRegistry

## Save/Load system
const SAVE_DIR := "user://saves/"

func save_data(slot: int, extra_data: Dictionary = {}) -> Error:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var save_dict := {
		"day_counter": _day_counter,
		"game_seed": _game_seed,
		"speed": speed,
		"damage": damage,
		"health": health,
		"max_health": max_health,
		"points": points,
		"attack_speed": attack_speed,
		"acidity": acidity,
		"stamina": stamina,
		"max_stamina": max_stamina,
	}
	save_dict.merge(extra_data)
	var file := FileAccess.open(SAVE_DIR + "slot_%d.save" % slot, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_var(save_dict)
	return OK

func load_data(slot: int) -> Dictionary:
	var path := SAVE_DIR + "slot_%d.save" % slot
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var data: Dictionary = file.get_var()
	if data.is_empty():
		return {}
	_day_counter = data.get("day_counter", 0)
	_game_seed = data.get("game_seed", 0)
	speed = data.get("speed", 1.0)
	damage = data.get("damage", 10)
	health = data.get("health", 100)
	max_health = data.get("max_health", 100)
	points = data.get("points", 0)
	attack_speed = data.get("attack_speed", 1.0)
	acidity = data.get("acidity", 0.0)
	stamina = data.get("stamina", 100.0)
	max_stamina = data.get("max_stamina", 100.0)
	return data

func set_player_pos(pos: Vector2) -> void:
	player_pos = pos
	
func get_player_pos() -> Vector2:
	return player_pos
