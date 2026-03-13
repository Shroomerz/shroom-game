extends IdleState

func handle_input(event: InputEvent) -> State:
	if move_component.get_movement_direction() != Vector2.ZERO:
		return move_state

	if event.is_action_pressed("attack"):
		if GameState.stamina >= GameState.STAMINA_ATTACK_COST:
			return attack_state

	return null

func process(delta: float) -> State:
	GameState.regen_stamina(delta)
	return null
