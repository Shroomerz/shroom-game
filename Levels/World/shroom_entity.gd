extends Node2D

var _pickup_cb
var shroom: IngredientSpecimen
@onready var pickup_area: Area2D = $Area2D
@onready var _sprite: Sprite2D = $Area2D/Sprite2D
@onready var _subviewport: SubViewport = $SubViewport

func setup(shroom_: IngredientSpecimen, pickup_cb) -> void:
	shroom = shroom_
	shroom.name = "shroom"
	_pickup_cb = pickup_cb

func _ready() -> void:
	_subviewport.add_child(shroom)
	pickup_area.body_entered.connect(_pickup_cb)
	#await RenderingServer.frame_post_draw
	#await RenderingServer.frame_post_draw
	#await RenderingServer.frame_post_draw
	#var image = _subviewport.get_texture().get_image()
	#var texture = ImageTexture.create_from_image(image)
	#_sprite.texture = texture
