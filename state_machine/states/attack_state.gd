class_name AttackState
extends State

@export var idle_state: IdleState
@export var move_state: MoveState

@export var hit_box: HitBox
@export var deceleration_speed: int
@export var attack_speed: float
@export var cooldown_time: float = 0.3

var is_complete: bool
var _cooldown_remaining: float = 0.0

func enter() -> void:
	if _cooldown_remaining > 0:
		is_complete = true
		return
	is_complete = false
	hit_box.monitorable = true
	super()
	parent.anim.speed_scale = attack_speed
	await parent.anim.animation_finished
	is_complete = true
	_cooldown_remaining = cooldown_time

func exit() -> void:
	parent.anim.speed_scale = 1.0
	hit_box.monitorable = false
	
func process_physics(delta: float) -> State:
	if _cooldown_remaining > 0:
		_cooldown_remaining -= delta
	parent.velocity -= parent.velocity * delta * deceleration_speed
	parent.move_and_slide()

	if not is_complete:
		return null

	if move_component.get_movement_direction() == Vector2.ZERO:
		return idle_state
	else:
		return move_state
