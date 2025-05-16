extends Node

class_name Item

var ID:String = "FFFF_0000" #naming like category + _ + idnumbr 
var description:String = "Use this item and journal results!"
var type:String = "2d" #2d or 3d
var usable:bool = false
var stackable:bool = false

func _init():
	name = "Unknown"

func is_stackable()->bool:
	return stackable

func is_usable():
	return  usable

func use():
	return -1

func create_world_entity():
	var entity = preload("res://Levels/World/item_entity.tscn").instantiate()
	entity.set_item(self)
	return entity

func create_inventory_entity():
	var blank
	if(type == "2d"):
		blank = load("res://assets/icon.svg")
	else:
		blank = load("res://Levels/Mock/2dMockSceene.tscn")
	return blank
