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

var _chord_timer: float = randf_range(5.0, 15.0)  # espera inicial aleatoria
var _chord_duration: float = 0.0
var _chord_active: bool = false
var _chord_root: float = 0.0
var _chord_phases: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var _chord_glide_speed: float = 0.0
var _chord_current_pitch: float = 1.0
var _chord_target_pitch: float = 1.0

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
		_phase_wind = _phase_wind * 0.97 + noise * 0.03
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

		# ── Harmonic chord layer: major chords that glide upward ──────────────
		const MAJOR_CHORD := [
	1.0,       # raíz       (1ª)
	1.25992,   # tercera    (3ª)  — 4 semitonos
	1.49831,   # quinta     (5ª)  — 7 semitonos
	1.78180,   # séptima    (7ª)  — 11 semitonos (maj7)
	2.00000,   # novena     (9ª)  — 12 semitonos (octava)
	2.24492,   # undécima   (11ª) — 16 semitonos
	2.66667,   # decimotercera (13ª) — 21 semitonos (maj13)
	3.00000,   # decimoquinta  (15ª) — 24 semitonos (dos octavas)
]

		if _chord_active:
			_chord_duration -= inv_rate

			# Glide suave: interpolar pitch actual hacia el objetivo
			_chord_current_pitch = move_toward(
				_chord_current_pitch,
				_chord_target_pitch,
				_chord_glide_speed * inv_rate
			)

			# Envolvente: fade-in rápido, sustain, fade-out suave al final
			var env: float
			var fade_time := 0.4
			var elapsed := (_chord_duration)   # tiempo restante
			var total := _chord_timer           # guardamos duración total al inicio (ver abajo)
			# Usamos _chord_timer como "tiempo ya transcurrido" durante el acorde
			_chord_timer += inv_rate
			var t_elapsed := _chord_timer
			var t_total := _chord_duration + _chord_timer
			var t_progress := _chord_timer / t_total
			env = sin(t_progress * PI)

			# Sumar las tres voces del acorde
			for v in MAJOR_CHORD.size():
				var freq :float = _chord_root * MAJOR_CHORD[v] * _chord_current_pitch
				_chord_phases[v] += freq * inv_rate
				# Las voces superiores son progresivamente más suaves
				var voice_vol := 0.045 * pow(0.75, v)
				sample += sin(_chord_phases[v] * TAU) * voice_vol * env

			if _chord_duration <= 0.0:
				_chord_active = false
				_chord_timer = _rng.randf_range(8.0, 10.0)  # pausa hasta el próximo acorde
		else:
			_chord_timer -= inv_rate
			if _chord_timer <= 0.0:
				# Activar nuevo acorde
				_chord_active = true
				_chord_root = _rng.randf_range(30.0, 320.0)
				_chord_duration = _rng.randf_range(3.0, 7.0)
				_chord_timer = 0.0   # se usará como contador de tiempo transcurrido
				_chord_current_pitch = 1.0
				var semitones := _rng.randf_range(1.0, 4.0)
				var direction := 1.0 if _rng.randf() > 0.5 else -1.0
				_chord_target_pitch = pow(2.0, direction * semitones / 12.0)
				_chord_glide_speed = (_chord_target_pitch - _chord_current_pitch) / _chord_duration
				# Resetear fases
				for v in MAJOR_CHORD.size():
					_chord_phases[v] = _rng.randf()   # fase aleatoria evita clic
		# ── Fin capa de acordes ───────────────────────────────────────────────

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
