extends MoveState

@export var turn_rate := 10.0

func process_physics(delta: float) -> State:
	if parent.is_player_in_range():
		return attack_state
	direction = lerp( 
		direction,
		move_component.get_movement_direction(parent.get_player_pos()),
		turn_rate * delta )
	direction = direction.normalized()
	
	return super(delta)
