class_name Player
extends CharacterBody2D

var face_direction := "S"
var invulnerable := false
var invulnerable_time := 0.1

# The ancient sequence, known only to the worthy
var _konami := ["up","up","down","down","left","right","left","right","b","a"]
var _konami_progress := 0
var _ascended := false

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var move_component = $MoveComponent
@onready var _tile_size: int = $"../Tiles".tile_set.tile_size.x * $"../Tiles".scale.x

func _ready() -> void:
	state_machine.init(self, move_component)
	
func _unhandled_input(event: InputEvent) -> void:
	_check_konami(event)
	state_machine.handle_input(event)

func _check_konami(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	var key_map := {
		KEY_UP: "up", KEY_DOWN: "down", KEY_LEFT: "left", KEY_RIGHT: "right",
		KEY_B: "b", KEY_A: "a"
	}
	var key_name: String = key_map.get(event.keycode, "")
	if key_name == "":
		_konami_progress = 0
		return
	if key_name == _konami[_konami_progress]:
		_konami_progress += 1
		if _konami_progress >= _konami.size():
			_konami_progress = 0
			_activate_shroom_mode()
	else:
		_konami_progress = 0

func _activate_shroom_mode() -> void:
	if _ascended:
		return
	_ascended = true
	GameState.speed += 0.5
	GameState.damage += 42
	GameState.max_health += 69
	GameState.health = GameState.max_health
	GameState.stamina = GameState.max_stamina
	# a e s t h e t i c
	var tween := create_tween().set_loops(3)
	tween.tween_property(sprite, "modulate", Color(1.0, 0.4, 1.0), 0.3)
	tween.tween_property(sprite, "modulate", Color(0.4, 1.0, 0.6), 0.3)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.3)
	print("🍄 SHROOM MODE ACTIVATED 🍄")

func _process(delta: float) -> void:
	if invulnerable_time > 0:
		invulnerable_time -= delta
	else:
		invulnerable = false
	state_machine.process(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func set_face_direction(target: Vector2) -> bool:
	var new_dir := DirectionUtils.vector_to_direction(target)
	if new_dir == "" or new_dir == face_direction:
		return false
	face_direction = new_dir
	return true
	
func update_animation(name: String) -> void:
	anim.play(name + "_" + face_direction)

func take_damage(damage: int) -> void:
	if invulnerable:
		return
	invulnerable = true;
	invulnerable_time = 0.1;
	GameState.take_damage(damage)
	
func get_super_coords() -> Vector2i:
	return Util.super_coords(get_coords())

func get_coords() -> Vector2i:
	var scaled := position / _tile_size
	return Vector2i(floori(scaled.x), floori(scaled.y))
