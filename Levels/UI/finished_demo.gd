extends CanvasLayer

@onready var fade_rect = $FadeRect
@onready var label = $VBoxContainer
@onready var quit = $VBoxContainer/HBoxContainer/quit
@onready var menu = $VBoxContainer/HBoxContainer/menu
@onready var scorespot = $VBoxContainer/MarginContainer3/Label
@onready var patience = $FadeRect/PanelContainer

func show_finish():
	#get_parent().process_mode = Node.PROCESS_MODE_PAUSABLE
	fade_rect.modulate.a = 0
	label.modulate.a = 0
	visible = true
	var fade_tween = create_tween()
	fade_tween.tween_property(fade_rect, "modulate:a", 0.8, 1.0)
	fade_tween.tween_callback(func(): fade_in_text())
	await get_tree().create_timer(2).timeout
	quit.grab_focus()

func fade_in_text():
	var text_tween = create_tween()
	text_tween.tween_property(label, "modulate:a", 1.0, 1.0)

func _process(delta: float) -> void:
	if get_parent().time_ratio >= 0.95:
		get_parent().time_ratio = 0
		scorespot.clear()
		scorespot.add_text("Score: " + str(GameState.points))
		show_finish()
		get_tree().paused = true;
		get_parent().process_mode = Node.PROCESS_MODE_PAUSABLE
	pass

func _ready():
	patience.visible = false;
	process_mode = Node.PROCESS_MODE_ALWAYS
	quit.process_mode = Node.PROCESS_MODE_ALWAYS
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

func _on_quit():
	get_tree().quit()
	
func _on_menu():
	quit.disabled = true
	menu.disabled = true
	patience.visible = true
	await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(0.6).timeout
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.hard_reset()
	get_tree().reload_current_scene()
	#get_tree().paused = false;
