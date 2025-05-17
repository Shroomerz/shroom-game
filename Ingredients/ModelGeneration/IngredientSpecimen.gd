extends Item
class_name IngredientSpecimen

var alchemy_stats

func _init():
	usable = true

func use():
	AlchemyStats.apply_stats(alchemy_stats)
