extends Control

@export var radius := 80.0
@export var thickness := 30.0
@export var resolution := 64

@export var outline_width := 5.0   # Outer black outline thickness

@export var day_color := Color.YELLOW      # bright yellow
@export var evening_color := Color.hex(0xFF6F59FF)   # sunset orange
@export var night_color := Color.hex(0x1E1E3FFF)     # rich dark blue

@export_range(0.0, 1.0, 0.01) var day_ratio := 0.35
@export_range(0.0, 1.0, 0.01) var evening_ratio := 0.15
@export_range(0.0, 1.0, 0.01) var night_ratio := 0.5

@export_range(0.0, 1.0, 0.001) var current_time_ratio := 0.0
@export var advance_time := true
@export var time_speed := 0.01

@onready var black := Color.BLACK
@onready var gray := Color.hex(0xAAAAAAFF)

@onready var tex_sun := load("res://assets/sun_64.png")
@onready var tex_moon := load("res://assets/moon.png")

func _get_time_ratio() -> float:
	return current_time_ratio

func _is_night_col(color: Color) -> bool:
	return color.to_rgba32() == night_color.to_rgba32()

func _draw():
	var center = size * 0.5
	var total_angle = 360.0

	# Draw outer black outline arc
	if outline_width > 0:
		draw_arc(center, radius + outline_width / 2.0, 0, TAU, resolution, black, outline_width + 2, 0.18)
		draw_arc(center, radius + outline_width / 2.0, 0, TAU, resolution, black, outline_width)

	# Draw black background circle
	draw_circle(center, radius, black)

	# Draw gray donut ring as base
	for i in range(resolution):
		var angle = TAU * float(i) / resolution
		var angle_next = TAU * float(i + 1) / resolution
		var outer1 = center + Vector2(cos(angle), sin(angle)) * radius
		var inner1 = center + Vector2(cos(angle), sin(angle)) * (radius - thickness)
		var outer2 = center + Vector2(cos(angle_next), sin(angle_next)) * radius
		var inner2 = center + Vector2(cos(angle_next), sin(angle_next)) * (radius - thickness)

		draw_colored_polygon([outer1, inner1, outer2], gray)
		draw_colored_polygon([outer2, inner1, inner2], gray)

	var segments = [
		{ "color": day_color, "ratio": day_ratio },
		{ "color": evening_color, "ratio": evening_ratio },
		{ "color": night_color, "ratio": night_ratio },
	]

	var current_angle = 180.0 # Start at left (9 o'clock)
	var angle_covered = 0.0
	var max_angle = _get_time_ratio() * total_angle

	for i in range(segments.size()):
		var curr = segments[i]
		var next = segments[(i + 1) % segments.size()]
		var segment_angle = curr.ratio * total_angle

		if angle_covered >= max_angle:
			break

		var draw_angle = min(segment_angle, max_angle - angle_covered)
		var steps = int(resolution * (draw_angle / total_angle))
		var transition_steps = max(6, int(steps * 0.25))

		for j in range(steps):
			var t = float(j) / steps
			var angle = deg_to_rad(current_angle + t * draw_angle)
			var next_t = float(j + 1) / steps
			var angle_next = deg_to_rad(current_angle + next_t * draw_angle)

			var outer1 = center + Vector2(cos(angle), sin(angle)) * radius
			var inner1 = center + Vector2(cos(angle), sin(angle)) * (radius - thickness)
			var outer2 = center + Vector2(cos(angle_next), sin(angle_next)) * radius
			var inner2 = center + Vector2(cos(angle_next), sin(angle_next)) * (radius - thickness)

			# Blending at segment boundaries only
			var is_transition = j >= steps - transition_steps
			var blend_amt = (float(j) - (steps - transition_steps)) / max(1, transition_steps)
			blend_amt = clamp(blend_amt, 0, 1)

			var color:Color = curr.color
			var glow_color := Color(0,0,0,0)

			if is_transition:
				color = curr.color.lerp(next.color, blend_amt)
				# Don't glow entering night
				if not _is_night_col(next.color):
					glow_color = color.lightened(0.4)
					glow_color.a = 0.3
			else:
				if not _is_night_col(curr.color):
					glow_color = curr.color.lightened(0.4)
					glow_color.a = 0.3

			# Glow
			if glow_color.a > 0:
				draw_colored_polygon([outer1, inner1, outer2], glow_color)
				draw_colored_polygon([outer2, inner1, inner2], glow_color)
			# Main color
			draw_colored_polygon([outer1, inner1, outer2], color)
			draw_colored_polygon([outer2, inner1, inner2], color)

		current_angle += draw_angle
		angle_covered += draw_angle

	# Draw sun/moon icon
	_draw_time_icon(center)

func _draw_time_icon(center: Vector2):
	var angle = deg_to_rad(180 + _get_time_ratio() * 360) # Start at left
	var icon_radius = radius - (thickness / 2)
	var icon_pos = center + Vector2(cos(angle), sin(angle)) * icon_radius
	var use_sun = _get_time_ratio() < (day_ratio + evening_ratio)
	var icon_tex = tex_sun if use_sun else tex_moon
	if icon_tex:
		var tex_size = icon_tex.get_size()
		draw_texture(icon_tex, icon_pos - tex_size / 2)

func _process(delta):
	if advance_time:
		current_time_ratio = fmod(current_time_ratio + delta * time_speed, 1.0)
	queue_redraw()
