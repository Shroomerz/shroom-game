extends Node

class_name Item

var itemID:String = "FFFF_0000" #naming like category + _ + idnumbr 
var description:String = "Use this item and journal results!"
var type:String = "2d" #2d or 3d
var usable:bool = false
var stackable:bool = false

func is_stackable()->bool:
	return stackable

func is_usable():
	return  usable

func use():
	return -1
