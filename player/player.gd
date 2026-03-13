class_name Player
extends CharacterBody2D

var face_direction := "S"
var invulnerable := false
var invulnerable_time := 0.1

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var move_component = $MoveComponent
@onready var _tile_size: int = $"../Tiles".tile_set.tile_size.x * $"../Tiles".scale.x

func _ready() -> void:
	state_machine.init(self, move_component)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

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
