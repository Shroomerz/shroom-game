extends AttackState

func enter() -> void:
	if not GameState.drain_stamina_attack():
		is_complete = true
		return
	hit_box.damage = GameState.damage
	attack_speed = GameState.attack_speed
	super()
