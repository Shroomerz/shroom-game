extends IdleState

func handle_input(event: InputEvent) -> State:
	if move_component.get_movement_direction() != Vector2.ZERO:
		return move_state
		
	if event.is_action_pressed("attack"):
		return attack_state
	
	return null
