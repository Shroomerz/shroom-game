extends Node
class_name AlchemyStats

static func get_distribution_of_distributions():
	return {
		"speed": DistributionOfDistributions.new(-0.5, 0.5, 0.05, 0.1),
		"damage": DistributionOfDistributions.new(-2, 2, 0.2, 0.4),
		"health": DistributionOfDistributions.new(-50, 50, 5, 20),
		"max health": DistributionOfDistributions.new(-30, 30, 5, 10),
		"attack speed": DistributionOfDistributions.new(-0.5, 0.5, 0.05, 0.1),
	}

static func calculate_points(stats: Dictionary):
	return max(0, stats["speed"] * -20 + stats["damage"] * -5 + stats["health"] * -0.5 + stats["max health"] / -3.0 + stats["attack speed"] * -20)

static func stats_to_strings(stats: Dictionary):
	return [
		["speed", str(stats["speed"])], 
		["damage", str(stats["damage"])], 
		["health", str(stats["health"])], 
		["max health", str(stats["max health"])], 
		["attack speed", str(stats["attack speed"])], 
		["points", str(AlchemyStats.calculate_points(stats))]]

static func apply_stats(stats: Dictionary):
	GameState.speed = min(0.1, stats["speed"])
	GameState.damage = min(0.5, stats["damage"])
	GameState.take_damage(-stats["health"])
	GameState.apply_max_health_change(stats["max health"])
	GameState.attack_speed = min(0.05, stats["attack speed"])
	GameState.give_points(calculate_points(stats))
