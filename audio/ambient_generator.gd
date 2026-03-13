## Procedural forest ambient generator.
## Layers filtered noise with slow sine drones for an organic forest soundscape.
## Fades out when enemies are nearby (combat).
extends Node

const MIX_RATE := 22050.0
const BUFFER_SIZE := 1024

var _playback: AudioStreamGeneratorPlayback
var _player: AudioStreamPlayer
var _phase_wind := 0.0
var _phase_birds := [0.0, 0.0, 0.0]
var _bird_freqs := [2637.0, 3520.0, 4186.0]  # E7, A7, C8 - birdsong register
var _bird_timers := [0.0, 0.0, 0.0]
var _bird_durations := [0.0, 0.0, 0.0]
var _drone_phases := [0.0, 0.0]
var _drone_freqs := [82.0, 110.0]  # low E2, A2 - forest hum
var _lfo_phase := 0.0
var _rng := RandomNumberGenerator.new()
var _volume_target := 1.0
var _volume_current := 0.0
var _combat_check_timer := 0.0
var _initialized := false

func _ready() -> void:
	_rng.seed = hash("leśny ambient z nutą tajemnicy")
	process_mode = Node.PROCESS_MODE_ALWAYS

	var stream := AudioStreamGenerator.new()
	stream.mix_rate = MIX_RATE
	stream.buffer_length = 0.1

	_player = AudioStreamPlayer.new()
	_player.stream = stream
	_player.bus = "Master"
	_player.volume_db = -8.0
	add_child(_player)
	_player.play()
	_playback = _player.get_stream_playback()
	_initialized = true

	for i in 3:
		_bird_timers[i] = _rng.randf_range(1.0, 5.0)
	# If it's Friday, the forest hums a bit differently
	if Time.get_datetime_dict_from_system()["weekday"] == Time.WEEKDAY_FRIDAY:
		_drone_freqs = [69.0, 113.0]  # nice.

func _process(delta: float) -> void:
	if not _initialized:
		return

	_combat_check_timer -= delta
	if _combat_check_timer <= 0:
		_combat_check_timer = 0.5
		_volume_target = 1.0 if _is_peaceful() else 0.0

	_volume_current = move_toward(_volume_current, _volume_target, delta * 2.0)
	_player.volume_db = lerp(-60.0, -8.0, _volume_current)

	_fill_buffer(delta)

func _fill_buffer(_delta: float) -> void:
	var frames_available: int = _playback.get_frames_available()
	if frames_available == 0:
		return

	var inv_rate := 1.0 / MIX_RATE
	for i in frames_available:
		var sample := 0.0

		# Wind layer: low-frequency filtered noise
		_lfo_phase += 0.3 * inv_rate
		var wind_volume := 0.15 * (0.5 + 0.5 * sin(_lfo_phase * TAU))
		var noise := (_rng.randf() * 2.0 - 1.0)
		_phase_wind = _phase_wind * 0.97 + noise * 0.03  # simple lowpass
		sample += _phase_wind * wind_volume

		# Drone layer: two quiet sine waves
		for d in 2:
			_drone_phases[d] += _drone_freqs[d] * inv_rate
			sample += sin(_drone_phases[d] * TAU) * 0.03

		# Bird chirps: sporadic sine bursts
		for b in 3:
			if _bird_timers[b] > 0:
				_bird_timers[b] -= inv_rate
			elif _bird_durations[b] > 0:
				_bird_durations[b] -= inv_rate
				_phase_birds[b] += _bird_freqs[b] * inv_rate
				var envelope := minf(_bird_durations[b] * 20.0, 1.0)
				sample += sin(_phase_birds[b] * TAU) * 0.06 * envelope
			else:
				_bird_timers[b] = _rng.randf_range(2.0, 8.0)
				_bird_durations[b] = _rng.randf_range(0.05, 0.2)
				_bird_freqs[b] = _rng.randf_range(2400.0, 5000.0)

		# Crickets: high frequency amplitude-modulated noise
		var cricket_mod := 0.5 + 0.5 * sin(_lfo_phase * TAU * 11.0)
		sample += (_rng.randf() * 2.0 - 1.0) * 0.02 * cricket_mod

		sample = clampf(sample, -1.0, 1.0)
		_playback.push_frame(Vector2(sample, sample))

func _is_peaceful() -> bool:
	if not is_instance_valid(get_tree()):
		return true
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return true
	var player_pos := GameState.get_player_pos()
	for enemy in enemies:
		if is_instance_valid(enemy) and enemy.global_position.distance_to(player_pos) < 300.0:
			return false
	return true
