extends GutTest

var game_ui

func before_each():
	game_ui = load("res://.../GameUI.gd").new()
	game_ui._ready()  # Simulate the _ready() call if needed for initialization

func after_each():
	game_ui = null

func test_update_health_bar():
	# Set initial health
	game_ui.update_health(100)
	
	# Check if health bar is updated correctly
	assert_eq(game_ui.health_bar.value, 100)
	
	# Update health
	game_ui.update_health(50)
	
	# Check if health bar reflects the change
	assert_eq(game_ui.health_bar.value, 50)

func test_update_stamina_bar():
	# Set initial stamina
	game_ui.update_stamina(100)
	
	# Check if stamina bar is updated correctly
	assert_eq(game_ui.stamina_bar.value, 100)
	
	# Update stamina
	game_ui.update_stamina(30)
	
	# Check if stamina bar reflects the change
	assert_eq(game_ui.stamina_bar.value, 30)

func test_health_and_stamina_update_together():
	# Update both health and stamina
	game_ui.update_health(75)
	game_ui.update_stamina(25)
	
	# Check if both bars are updated correctly
	assert_eq(game_ui.health_bar.value, 75)
	assert_eq(game_ui.stamina_bar.value, 25)

func test_health_bar_max_value():
	# Set max health
	game_ui.set_max_health(150)
	
	# Update health to max
	game_ui.update_health(150)
	
	# Check if health bar max value is set correctly
	assert_eq(game_ui.health_bar.max_value, 150)
	assert_eq(game_ui.health_bar.value, 150)

func test_stamina_bar_max_value():
	# Set max stamina
	game_ui.set_max_stamina(200)
	
	# Update stamina to max
	game_ui.update_stamina(200)
	
	# Check if stamina bar max value is set correctly
	assert_eq(game_ui.stamina_bar.max_value, 200)
	assert_eq(game_ui.stamina_bar.value, 200)

func test_health_bar_does_not_exceed_max():
	# Set max health
	game_ui.set_max_health(100)
	
	# Attempt to set health above max
	game_ui.update_health(150)
	
	# Check if health bar value is capped at max
	assert_eq(game_ui.health_bar.value, 100)

func test_stamina_bar_does_not_exceed_max():
	# Set max stamina
	game_ui.set_max_stamina(100)
	
	# Attempt to set stamina above max
	game_ui.update_stamina(150)
	
	# Check if stamina bar value is capped at max
	assert_eq(game_ui.stamina_bar.value, 100)

func test_health_bar_does_not_go_below_zero():
	# Set health to zero
	game_ui.update_health(0)
	
	# Attempt to set health below zero
	game_ui.update_health(-10)
	
	# Check if health bar value is not below zeros
	assert_eq(game_ui.health_bar.value, 0)

func test_stamina_bar_does_not_go_below_zero():
	# Set stamina to zero
	game_ui.update_stamina(0)
	
	# Attempt to set stamina below zero
	game_ui.update_stamina(-20)
	
	# Check if stamina bar value is not below zero
	assert_eq(game_ui.stamina_bar.value, 0)
