class_name Player
extends CharacterBody2D

var face_direction = "down"
var health:int = 100

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var state_machine = $StateMachine
@onready var move_component = $MoveComponent
@onready var interactions = $Interactions

func _ready() -> void:
	state_machine.init(self, move_component)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func _process(delta: float) -> void:
	state_machine.process(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func set_face_direction(target: Vector2) -> bool:
	var new_dir = face_direction
	
	if target == Vector2.ZERO:
		return false
		
	if abs(target.y) > abs(target.x):
		new_dir = "down" if target.y > 0 else "up"
	else:
		new_dir = "right" if target.x > 0 else "left"
		 
	sprite.flip_h = true if new_dir == "left" else false
		
	if new_dir == face_direction:
		return false
	
	interactions.update_direction(new_dir)
	face_direction = new_dir
	return true
	
func update_animation(name: String) -> void:
	var dir = face_direction
	if dir == "right" or dir == "left":
		dir = "side"
	animation.play(name + "_" + dir)
	

func take_damage(damage: int) -> void:
	health -= damage
	print("damage has been taken: &d" %damage)
	pass
