extends Node

func get_movment_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
