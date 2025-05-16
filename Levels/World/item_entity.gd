extends Node2D

var _item: Item = null

func set_item(item: Item) -> void:
	_item = item

func get_item() -> Item:
	return _item
