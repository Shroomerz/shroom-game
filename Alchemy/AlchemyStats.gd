extends Node
class_name AlchemyStats

func get_distribution_of_distributions():
	return {
		"speed": DistributionOfDistributions.new(-0.5, 0.5, 0.05, 0.1),
		"damage": DistributionOfDistributions.new(-2, 2, 0.2, 0.4),
		"health": DistributionOfDistributions.new(-50, 50, 5, 20),
		"max health": DistributionOfDistributions.new(-30, 30, 5, 10),
		"attack speed": DistributionOfDistributions.new(-0.5, 0.5, 0.05, 0.1),
	}

func calculate_points(stats: Dictionary):
	return max(0, stats["speed"] * -20 + stats["damage"] * -5 + stats["health"] * -0.5 + stats["max health"] / -3.0 + stats["attack speed"] * -20)

func stats_to_strings(stats: Dictionary):
	return [["speed", stats["speed"]], ["damage", stats["damage"]], ["health", stats["health"]], ["max health", stats["max health"]], ["attack speed", stats["attack speed"]]]
