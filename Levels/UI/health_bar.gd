extends Control

var healthbar: TextureProgressBar

const BAR_WIDTH := 800
const BAR_HEIGHT := 100
const OUTLINE_THICKNESS := 5

func _ready():
	var max_health := GameState.max_health
	var current_health := GameState.health

	# Create the health bar node
	healthbar = TextureProgressBar.new()
	healthbar.min_value = 0
	healthbar.max_value = max_health
	healthbar.value = current_health
	healthbar.position = Vector2(50, 50)
	healthbar.size = Vector2(BAR_WIDTH, BAR_HEIGHT)

	# Use solid colors for the bar
	var bg_tex = _make_colored_texture(Color(0.2, 0.2, 0.2), BAR_WIDTH, BAR_HEIGHT)
	var fg_tex = _make_colored_texture(Color(0.2, 0.9, 0.2), BAR_WIDTH, BAR_HEIGHT)
	var outline_tex = _make_colored_outline_texture(Color.BLACK, BAR_WIDTH, BAR_HEIGHT, OUTLINE_THICKNESS)

	healthbar.texture_under = bg_tex
	healthbar.texture_progress = fg_tex
	healthbar.texture_over = outline_tex

	add_child(healthbar)
	healthbar.position -= Vector2(160, -150)

func update_bar():
	if healthbar:
		healthbar.max_value = GameState.max_health
		healthbar.value = GameState.health

func _make_colored_texture(col: Color, w: int, h: int, line_only := false) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for x in w:
		for y in h:
			if line_only and (x == 0 or y == 0 or x == w-1 or y == h-1):
				img.set_pixel(x, y, col)
			elif not line_only:
				img.set_pixel(x, y, col)
	var tex := ImageTexture.create_from_image(img)
	return tex

func _make_colored_outline_texture(col: Color, w: int, h: int, t: int) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for x in w:
		for y in h:
			if (x < t or y < t or x >= w-t or y >= h-t):
				img.set_pixel(x, y, col)
	var tex := ImageTexture.create_from_image(img)
	return tex

func _process(_delta):
	update_bar()
