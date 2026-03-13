class_name DirectionUtils

## Converts a movement vector to an 8-direction string (N, NE, E, SE, S, SW, W, NW).
## Returns "" if the vector is zero.
static func vector_to_direction(target: Vector2) -> String:
	if target == Vector2.ZERO:
		return ""

	var angle: float = rad_to_deg(target.angle())
	if angle < 0:
		angle += 360

	if angle >= 337.5 or angle < 22.5:
		return "E"
	elif angle >= 22.5 and angle < 67.5:
		return "SE"
	elif angle >= 67.5 and angle < 112.5:
		return "S"
	elif angle >= 112.5 and angle < 157.5:
		return "SW"
	elif angle >= 157.5 and angle < 202.5:
		return "W"
	elif angle >= 202.5 and angle < 247.5:
		return "NW"
	elif angle >= 247.5 and angle < 292.5:
		return "N"
	else:
		return "NE"
