class_name Enemy
extends CharacterBody2D

var face_direction = "S"
var invulnerable := false
var invulnerable_time := 0.0
var attack_range := 20.0
@export var point_value := 5
@export var health := 30.0

@onready var anim = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var move_component = $MoveComponent

func _ready() -> void:
	add_to_group("enemies")
	state_machine.init(self, move_component)
	
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
	health -= damage
	if health < 0:
		die()
		
func die():
	GameState.give_points(point_value)
	# 1 in 100 chance the goblin has last words
	if randi() % 100 == 0:
		print("[Goblin's dying whisper]: \"Tell my wife... I said... hello.\"")
	queue_free()
	
func get_player_pos() -> Vector2:
	return global_position.direction_to(GameState.get_player_pos())
	
func get_player_distance() -> float:
	return global_position.distance_to(GameState.get_player_pos())
	
func is_player_in_range() -> bool:
	return get_player_distance() < attack_range

