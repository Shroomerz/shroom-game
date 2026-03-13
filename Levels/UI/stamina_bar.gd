extends Control

var staminabar: TextureProgressBar

const BAR_WIDTH := 800
const BAR_HEIGHT := 60
const OUTLINE_THICKNESS := 4

func _ready():
	staminabar = TextureProgressBar.new()
	staminabar.min_value = 0
	staminabar.max_value = GameState.max_stamina
	staminabar.value = GameState.stamina
	staminabar.position = Vector2(50, 50)
	staminabar.size = Vector2(BAR_WIDTH, BAR_HEIGHT)

	var bg_tex = _make_colored_texture(Color(0.2, 0.2, 0.2), BAR_WIDTH, BAR_HEIGHT)
	var fg_tex = _make_colored_texture(Color(0.85, 0.75, 0.15), BAR_WIDTH, BAR_HEIGHT)
	var outline_tex = _make_colored_outline_texture(Color.BLACK, BAR_WIDTH, BAR_HEIGHT, OUTLINE_THICKNESS)

	staminabar.texture_under = bg_tex
	staminabar.texture_progress = fg_tex
	staminabar.texture_over = outline_tex

	add_child(staminabar)
	staminabar.position -= Vector2(160, -150)

func update_bar():
	if staminabar:
		staminabar.max_value = GameState.max_stamina
		staminabar.value = GameState.stamina

func _make_colored_texture(col: Color, w: int, h: int) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for x in w:
		for y in h:
			img.set_pixel(x, y, col)
	return ImageTexture.create_from_image(img)

func _make_colored_outline_texture(col: Color, w: int, h: int, t: int) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for x in w:
		for y in h:
			if (x < t or y < t or x >= w - t or y >= h - t):
				img.set_pixel(x, y, col)
	return ImageTexture.create_from_image(img)

func _process(_delta):
	update_bar()
