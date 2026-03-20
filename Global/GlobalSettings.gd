extends Node

enum Difficulty { EASY, MEDIUM, HARD }

var res_index
var fullscreen
var borderless
var volume
var darkmode
var difficulty: int = Difficulty.MEDIUM

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2880,1800),
	Vector2i(3840,2160),
]

func apply_theme(theme_path):
	# Load the theme
	var new_theme = load(theme_path)
	if new_theme:
		# Apply the theme to the root of the scene tree
		get_tree().root.theme = new_theme
		
	else:
		printerr("Failed to load theme: ", theme_path)


func _ready():	
	load_settings()
	apply_settings()


func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		# Load resolution
		res_index = config.get_value("graphics", "resolution_index", 0)
		
		# Load fullscreen
		fullscreen = config.get_value("graphics", "fullscreen", false)
		
		#Load borders
		borderless = config.get_value("graphics", "borderless", false)
	
		# Load volume
		volume = config.get_value("audio", "master_volume", 0.5)
		
		#load theme
		darkmode = config.get_value("theme", "dark", true)
		# load difficulty
		difficulty = config.get_value("gameplay", "difficulty", Difficulty.MEDIUM)
	else:
		#else load default values
		res_index = 2
		fullscreen = true
		borderless = false
		volume = 0.5
		darkmode = true
		difficulty = Difficulty.MEDIUM


func apply_settings():	
	# Set the new resolution
	DisplayServer.window_set_size(resolutions[res_index])
	await get_tree().process_frame  # Wait one frame
	
	# Apply fullscreen setting (toggle window mode)
	#setting the window to opposite of what you want and back seems to fix focus loss issues
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		await get_tree().process_frame  # Wait one frame
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		await get_tree().process_frame  # Wait one frame
	#Apply borderless
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderless)
	await get_tree().process_frame  # Wait one frame
		
	# Apply volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))

	#Apply theme
	if darkmode:
		apply_theme("res://themes/build/dark_theme.tres")
	else:
		apply_theme("res://themes/build/light_theme.tres")
	
	# Save settings
	var config = ConfigFile.new()
	config.set_value("graphics", "resolution_index", res_index)
	config.set_value("graphics", "fullscreen", fullscreen)
	config.set_value("graphics", "borderless", borderless)
	config.set_value("audio", "master_volume", volume)
	config.set_value("theme", "dark", darkmode)
	config.set_value("gameplay", "difficulty", difficulty)
	config.save("user://settings.cfg")
	
	print("Settings applied and saved.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
