extends MoveState

var base_move_speed: int
const SPRINT_MULTIPLIER := 1.6

func enter() -> void:
	base_move_speed = move_speed
	super()

func exit() -> void:
	move_speed = base_move_speed
	super()

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack"):
		if GameState.stamina >= GameState.STAMINA_ATTACK_COST:
			return attack_state

	return null

func process_physics(delta: float) -> State:
	var is_sprinting := Input.is_action_pressed("sprint") and GameState.stamina > 0

	if is_sprinting:
		GameState.drain_stamina_sprint(delta)
		move_speed = int(base_move_speed * GameState.speed * SPRINT_MULTIPLIER)
	else:
		GameState.regen_stamina(delta)
		move_speed = int(base_move_speed * GameState.speed)

	direction = move_component.get_movement_direction()
	return super(delta)
