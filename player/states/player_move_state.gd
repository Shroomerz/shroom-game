extends MoveState

var base_move_speed: int

func enter() -> void:
	base_move_speed = move_speed
	super()
	
func exit() -> void:
	move_speed = base_move_speed
	super()

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack"):
		return attack_state
	
	return null

func process_physics(delta: float) -> State:
	move_speed = base_move_speed * GameState.speed
	direction = move_component.get_movement_direction()
	return super(delta)
