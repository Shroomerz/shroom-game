## A white noise generator with an API similar to a subset of that of [Noise].
##
## You can think of it as an infinite 3D array filled wth pseudorandom floats,
## evenly distributed between [code]-1[/code] and [code]1[/code].
class_name WhiteNoise

## The seed for the noise.
var seed: int

func get_noise_3d(x: int, y: int, z: int) -> float:
	# Simple hash-based white noise using integer arithmetic (much faster than SHA256)
	var h: int = seed
	h = h ^ (x * 374761393)
	h = h ^ (y * 668265263)
	h = h ^ (z * 1274126177)
	h = (h ^ (h >> 13)) * 1274126177
	h = h ^ (h >> 16)
	return float(h & 0xFFFFFF) / float(0xFFFFFF) * 2.0 - 1.0

func get_noise_2d(x: int, y: int) -> float:
	return get_noise_3d(x, y, 0)

func get_noise_1d(x: int) -> float:
	return get_noise_3d(x, 0, 0)

func get_noise_3dv(xyz: Vector3i) -> float:
	return get_noise_3d(xyz.x, xyz.y, xyz.z)

func get_noise_2dv(xy: Vector2i) -> float:
	return get_noise_3d(xy.x, xy.y, 0)
