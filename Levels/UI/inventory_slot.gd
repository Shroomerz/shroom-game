extends Control

@onready var icon = $ItemIcon
@onready var viewport_container = $Viewport
@onready var viewport = $Viewport/SubViewport
@onready var button = $butt
@onready var text = $RichTextLabel

signal slot_clicked(slot_data)
signal slot_focused(slot_data)
signal slot_unfocused(slot_data)

var data:Item
var quantity:int

func show_item(item:Item, _quantity:int):
	data = item
	quantity = _quantity

	if(item.type == "2d"):
		icon.texture = item.get_texture()
		viewport_container.visible = false
	else:
		viewport.add_child(item)
		icon.visible = false
	if(quantity >= 2):
		text.visible = true
		text.clear()
		text.add_text(str(quantity))	
	else:
		text.visible = false
		
func _ready():
	button.connect("pressed", self._on_pressed)
	button.connect("focus_entered", self._on_focus_entered)
	button.connect("focus_exited", self._on_focus_exited)

func _on_pressed():
	emit_signal("slot_clicked", data)

func _on_focus_entered():
	emit_signal("slot_focused", data)

func _on_focus_exited():
	emit_signal("slot_unfocused", data)
