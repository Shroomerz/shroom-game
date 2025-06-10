extends Control

#############################################################################
#Node adding
###############################################################################
# menu nodes
@onready var fullmenu = $Menu
@onready var game_button = $Menu/MenuPanel/MarginContainer/VBoxContainer/game
@onready var options_button = $Menu/MenuPanel/MarginContainer/VBoxContainer/options
@onready var creds_button = $Menu/MenuPanel/MarginContainer/VBoxContainer/creds
@onready var exit_button = $Menu/MenuPanel/MarginContainer/VBoxContainer/ausgang
@onready var menu = $Menu/MenuPanel
@onready var settings = $Settings
# menu exit nodes
@onready var no_button = $exit_confirm/ColorRect/MarginContainer/VBoxContainer/no
@onready var yes_button = $exit_confirm/ColorRect/MarginContainer/VBoxContainer/yes
@onready var confirm = $exit_confirm
@onready var logos = $Menu/logo_buttons
# settings nodes
@onready var main_panel = $Settings
@onready var resolution_option = $Settings/MarginContainer/VBox/ResPanel/MarginContainer/ResolutionOption
@onready var fullscreen_check = $Settings/MarginContainer/VBox/FullscreenPanel/MarginContainer/FullscreenCheck
@onready var border_check = $Settings/MarginContainer/VBox/BorderPanel/MarginContainer/BorderCheck
@onready var volume_slider = $Settings/MarginContainer/VBox/VolPanel/MarginContainer/SoundSlide
@onready var darkmode_check = $Settings/MarginContainer/VBox/DarkPanel/MarginContainer/DarkCheck
@onready var apply_button = $Settings/MarginContainer/VBox/HBoxContainer/MarginContainer/Apply
#settings exit nodes
@onready var exit_settings = $exit_settings_confirm
@onready var exit_save = $exit_settings_confirm/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/yes
@onready var exit_discard = $exit_settings_confirm/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/no

#credits node
@onready var credits = $Menu/Credits
@onready var credit_back = $Menu/Credits/MarginContainer/VBox/Back

#world node
@onready var world = $World
@onready var lefttop = $World/LeftTopDisplayers
#inventory nodes
@onready var inv = $Inventory

#Pause Menu
@onready var pause = $Pause
@onready var pauseBack = $Pause/MarginContainer/VBox/Back
@onready var pauseMenu = $Pause/MarginContainer/VBox/MainMenu
@onready var pauseHelp = $Help
@onready var pauseHelpBack = $Help/MarginContainer/VBox/Back

#Clock
@onready var clock = $World/LeftTopDisplayers/SunClock
###############################################################
#variables
#################################################################

#settings variables
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2880,1800),
	Vector2i(3840,2160),
]
var changes = false
var last_volume_value

#for time
var time_ratio = 0.0

################################################################################
#GODOT functions
##################################################################################

func _ready():
	game_button.grab_focus()
	for res in resolutions:
		resolution_option.add_item("%dx%d" % [res.x, res.y])
		
	load_settings()
	last_volume_value = volume_slider.value
	#toggleWorldPause()
	get_tree().paused = true

func _input(event):
	if(event.is_action_pressed("ui_cancel") && settings.visible):
		toggleSettings()
		if changes:
			toggleSettingsconfirm()
		else:
			if(!world.visible): # && !hut.visible
				togglemenu()
			else:
				togglePause()
		
	elif(event.is_action_pressed("ui_cancel") && credits.visible):
		togglecredit()
		togglemenu()
	elif(event.is_action_pressed("ui_cancel") && confirm.visible):
		toggleconfirm()
		togglemenu()
	elif(event.is_action_pressed("ui_cancel") && menu.visible && fullmenu.visible):
		togglemenu()
		toggleconfirm()
	elif(event.is_action_pressed("inv") && world.visible && !pause.visible):
		toggleWorldPause()
		toggleInv()
	elif(event.is_action_pressed("ui_cancel") && inv.visible):
		toggleInv()
		toggleWorldPause()
	elif(event.is_action_pressed("ui_cancel") && world.visible && !pause.visible && !settings.visible && !pauseHelp.visible):
		togglePause()
		toggleClockPause()
		toggleWorldPause()
	elif(event.is_action_pressed("ui_cancel") && pause.visible && !settings.visible && !exit_settings.visible && !pauseHelp.visible):
		togglePause()
		toggleClockPause()
		toggleWorldPause()
	elif(event.is_action_pressed("ui_cancel") && pauseHelp.visible && !settings.visible && !exit_settings.visible):
		togglePauseHelp()
	
		
func _process(_delta):
	if volume_slider.value != last_volume_value:
		last_volume_value = volume_slider.value
		_on_sound_slide_changed()
#############################################################################
#panel swapping
#######################################################################################
func togglemenu():
	menu.visible = !menu.visible
	logos.visible = menu.visible
	await get_tree().process_frame
	if(menu.visible):
		game_button.grab_focus()
		
func toggleSettings():
	settings.visible = !settings.visible
	await get_tree().process_frame
	if(settings.visible):
		resolution_option.grab_focus()

func toggleconfirm():
	confirm.visible = !confirm.visible
	await get_tree().process_frame
	if(confirm.visible):
		yes_button.grab_focus()

func toggleSettingsconfirm():
	exit_settings.visible = !exit_settings.visible
	await get_tree().process_frame
	if(exit_settings.visible):
		exit_discard.grab_focus()

func togglecredit():
	credits.visible = !credits.visible
	await get_tree().process_frame
	if(credits.visible):
		credit_back.grab_focus()
	
func toggleFullMenu():
	fullmenu.visible = !fullmenu.visible
	await get_tree().process_frame
	if(fullmenu.visible):
		game_button.grab_focus()

func toggleWorld():
	world.visible = !world.visible
	
func toggleInv():
	inv.visible = !inv.visible
	if(inv.visible):
		inv.populate()
	else:
		inv.clear()

func togglePause():
	pause.visible = !pause.visible
	await get_tree().process_frame
	if(pause.visible):
		pauseBack.grab_focus()
		pauseMenu.disabled = false
	
func toggleWorldPause():
	get_tree().paused = !get_tree().paused

func toggleClockPause():
		clock.advance_time = !clock.advance_time
	
func togglePauseHelp():
	pauseHelp.visible = !pauseHelp.visible
	pause.visible = !pause.visible
	await get_tree().process_frame
	if pauseHelp.visible:
		pauseHelpBack.grab_focus()
	else:
		pauseBack.grab_focus()
	
##################################################################################################
#main menu buttons
##################################################################################################
func _on_game_pressed() -> void:
	toggleFullMenu()
	toggleWorldPause()
	toggleClockPause()
	toggleWorld()


func _on_options_pressed() -> void:
	togglemenu()
	toggleSettings()


func _on_creds_pressed() -> void:
	togglemenu()
	togglecredit()


func _on_ausgang_pressed() -> void:
	togglemenu()
	toggleconfirm()


########################################################################
#GAME EXIT BUTTONS
########################################################################
func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	toggleconfirm()
	togglemenu()


#######################################################################
#Settings utility
#######################################################################
func load_settings():
	#Load resolution
	resolution_option.select(GlobalSettings.res_index)
	# Load fullscreen
	fullscreen_check.button_pressed = GlobalSettings.fullscreen
	#Load borders
	border_check.button_pressed = GlobalSettings.borderless
	# Load volume
	volume_slider.value = GlobalSettings.volume
	#Load theme
	darkmode_check.button_pressed = GlobalSettings.darkmode
	changes = false
	
#########################################################################
#Settings buttons
#########################################################################

func _on_resolution_option_item_selected(_index: int) -> void:
	changes = true


func _on_fullscreen_check_pressed() -> void:
	changes = true


func _on_border_check_pressed() -> void:
	changes = true


func _on_dark_check_pressed() -> void:
	changes = true


func _on_sound_slide_changed() -> void:
	changes = true


func _on_apply_pressed():
	#update parameters of settings
	GlobalSettings.res_index = resolution_option.get_selected()
	GlobalSettings.fullscreen = fullscreen_check.button_pressed
	GlobalSettings.borderless = border_check.button_pressed
	GlobalSettings.volume = volume_slider.value
	GlobalSettings.darkmode = darkmode_check.button_pressed
	#apply parameters
	GlobalSettings.apply_settings()
	changes = false


func _on_yes_exitSettings_pressed() -> void:
	_on_apply_pressed()
	toggleSettingsconfirm()
	if(!world.visible): # && !hut.visible
		togglemenu()
	else:
		togglePause()


func _on_no_Settings_pressed() -> void:
	load_settings()
	toggleSettingsconfirm()
	if(!world.visible): # when adding hut change only this && !hut.visible
		togglemenu()
	else:
		togglePause()
		
func _on_back_settings_pressed() -> void:
	toggleSettings()
	if(!world.visible):
		togglemenu()
	else:
		togglePause()

##################################################################
#Credits buttons
####################################################################

func _on_back_credits_pressed() -> void:
	togglecredit()
	togglemenu()

######################################################################
#Pause buttons
######################################################################

func _on_main_menu_pressed() -> void:
	toggleWorldPause()
	togglePause()
	toggleWorld()
	toggleFullMenu()


func _on_pause_settings_pressed() -> void:
	togglePause()
	toggleSettings()


func _on_pause_back_pressed() -> void:
	toggleWorldPause()
	togglePause()
	
func _on_pause_help_pressed()-> void:
	togglePauseHelp()
	
func  _on_pause_help_back_pressed()->void:
	togglePauseHelp()
	
###################################################
#############NOT YET IMPLEMENTED
######################################################
@onready var health_bar = $Settings/MarginContainer/VBox/VolPanel/MarginContainer/SoundSlide
@onready var stamina_bar = health_bar

func set_max_health(val):
	pass

func update_health(val):
	pass
	
func set_max_stamina(val):
	pass

func update_stamina(val):
	pass


func _on_pause_main_menu_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.hard_reset()
	get_tree().reload_current_scene()
	#get_tree().paused = false;
	


func _on_logo_button_pressed() -> void:
	OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ&autoplay=1")
