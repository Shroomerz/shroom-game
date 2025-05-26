extends Node
class_name AlchemyStats

static func get_distribution_of_distributions():
	return {
		"speed": DistributionOfDistributions.new(-0.5, 1.0, 0.05, 0.1),
		"damage": DistributionOfDistributions.new(-2, 4, 0.2, 0.4),
		"health": DistributionOfDistributions.new(-50, 100, 5, 20),
		"max health": DistributionOfDistributions.new(-30, 60, 5, 10),
		"attack speed": DistributionOfDistributions.new(-0.5, 1.0, 0.05, 0.1),
		"acidity": DistributionOfDistributions.new(-5.0, 15.0, 3.0, 3.1)
	}

static func calculate_points(stats: Dictionary):
	return max(0, stats["speed"] * -20 + stats["damage"] * -5 + stats["health"] * -0.5 + stats["max health"] / -3.0 + stats["attack speed"] * -20) + stats["acidity"]

static func stats_to_strings(stats: Dictionary):
	return [
		["speed", str(stats["speed"]).pad_decimals(2)], 
		["damage", str(stats["damage"]).pad_decimals(2)], 
		["health", str(stats["health"]).pad_decimals(2)], 
		["max health", str(stats["max health"]).pad_decimals(2)], 
		["attack speed", str(stats["attack speed"]).pad_decimals(2)], 
		["acidity", str(stats["acidity"]).pad_decimals(2)],
		["points", str(AlchemyStats.calculate_points(stats)).pad_decimals(2)],
]

static func apply_stats(stats: Dictionary):
	GameState.apply_speed_change(min(0.1, stats["speed"]))
	GameState.apply_damage_change(min(0.5, stats["damage"]))
	GameState.take_damage(-stats["health"])
	GameState.apply_max_health_change(stats["max health"])
	GameState.apply_attack_speed_change(min(0.05, stats["attack speed"]))
	GameState.give_points(calculate_points(stats))
	GameState.apply_acidity(stats["acidity"])
