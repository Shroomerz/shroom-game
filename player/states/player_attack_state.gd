extends AttackState

func enter() -> void:
	hit_box.damage = GameState.damage
	attack_speed = GameState.attack_speed
	GameState.drain_stamina_attack()
	super()
