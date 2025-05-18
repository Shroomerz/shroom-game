extends Control

@onready var grid = $ListingPanel/ScrollContainer/ItemList
@onready var itemD = $item_description
@onready var preview2d = $item_description/vbox/item_inspector/preview/Preview2d
@onready var preview3d = $item_description/vbox/item_inspector/preview/Preview3d
@onready var BigViewPort = $item_description/vbox/item_inspector/preview/Preview3d/SubViewport
@onready var Biglabel = $item_description/vbox/Name/BigLabel
@onready var Smalllabel = $item_description/vbox/Description/SmallLabel
@onready var useButton = $item_description/vbox/Button
var slot_scene = preload("res://Levels/UI/inventory_slot.tscn")
var last_data = null

func my_grab_focus():
	if grid.get_child_count() > 0:
		grid.get_child(0).get_child(0).get_child(2).grab_focus()

func populate():
	var inv:Inventory = GameState.get_inventory()
	inv.sort_cat()
	for i in range(0,inv.get_size()):
		var item:ItemStack = inv.get_obj_by_id(i)
		var slots:int = 1
		var per_slot:int = item.get_quantity()
		if(item.is_nonstack()):
			slots = per_slot
			per_slot = 1
		for j in range(slots):
			var slot = slot_scene.instantiate()
			var cont: MarginContainer = MarginContainer.new()
			cont.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cont.add_child(slot)
			grid.add_child(cont)
			slot.show_item(item.get_item(), per_slot)
			slot.connect("slot_clicked", self._on_slot_clicked)
			slot.connect("slot_focused", self._on_slot_focused)
			slot.connect("slot_unfocused", self._on_slot_unfocused)
	my_grab_focus()

func _ready():
	self.visible = false

func clear():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	Biglabel.clear()
	Smalllabel.clear()
	useButton.disabled = true
	preview3d.visible = false
	preview2d.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_slot_clicked(data):
	if(data.usable):
		useButton.grab_focus()
	last_data = data
	
func _on_slot_focused(data:Item):
	if(data.type == "2d"):
		preview3d.visible = false
		preview2d.visible = true
		preview2d.texture = data.create_inventory_entity()
	else:
		preview2d.visible = false
		preview3d.visible = true
		if(BigViewPort.get_child_count() != 0):
			BigViewPort.remove_child(BigViewPort.get_child(0))
		BigViewPort.add_child(data)
		
	Biglabel.clear()
	Smalllabel.clear()
	Biglabel.add_text(data.name)
	Smalllabel.add_text(data.description)
	
	useButton.disabled = !data.usable
	last_data = data

func _on_slot_unfocused(data):
	pass

func _on_use():
	last_data.use()
	GameState._inventory.remove_item(last_data.itemID,1)
	clear()
	populate()
