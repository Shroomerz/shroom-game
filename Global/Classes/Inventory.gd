class_name Inventory
var data: Array[ItemStack]

func get_id_by_id(ID:String)->int:
	for i in range(data.size()):
		if data[i].get_item().itemID == ID:
			return i
	return -1

func get_obj_by_item_id(ID:String)->ItemStack:
	var id:int = get_id_by_id(ID)
	return data[id]

func get_obj_by_id(id:int):
	return data[id]

func get_array()->Array[ItemStack]:
	return data

func sort_cat()->void:
	data.sort_custom(_compare_items_by_cat_id)

func _compare_items_by_cat_id(a:ItemStack, b:ItemStack) -> bool:
	var parts_a = a.item.itemID.split("_")
	var parts_b = b.item.itemID.split("_")

	var prefix_a = parts_a[0]
	var prefix_b = parts_b[0]
	if prefix_a != prefix_b:
		return prefix_a < prefix_b

	var num_a = int(parts_a[1]) if parts_a.size() > 1 else 0
	var num_b = int(parts_b[1]) if parts_b.size() > 1 else 0
	return num_a < num_b

func clear()->void:
	data.clear()

func add_item(item:Item, quantity:int)->void:
	var pos:int = get_id_by_id(item.itemID)
	if(pos != -1):
		data[pos].quantity += quantity
		return
	data.append(ItemStack.new(item, quantity))

func remove_item(ID:String, quantity:int)->bool:
	var pos:int = get_id_by_id(ID)
	if(pos == -1): return false
	if(data[pos].quantity <= quantity):
		data.remove_at(pos)
		return true
	data[pos].quantity -= quantity
	return true

func get_size():
	return data.size()

func _init() ->void:
	pass
	#var item := Item.new()
	#item.itemID = "test_01"
	#item.name = "Item #1"
	#item.description = "This is item number %1"
	#item.type = "2d"	
	#item.stackable = true
	#add_item(item,1)
	#item = Item.new()
	#item.itemID = "test_02"
	#item.name = "Item #2"
	#item.description = "This is item number %2"
	#item.type = "2d"	
	#item.stackable = true
	#add_item(item,5)
	#item = Item.new()
	#item.itemID = "ates_03"
	#item.name = "Item #3"
	#item.description = "This is item number %3"
	#item.usable = true
	#item.type = "3d"	
	#item.stackable = false
	#add_item(item,5)
	#print(data.size())
