extends CanvasLayer

signal plant_selected(plant_type_id: String)

@onready var win_screen = %WinScreen
@onready var restart_button = %WinScreen/MarginContainer/VBoxContainer/RestartButton
@onready var restart_level_button = %RestartLevelButton
@onready var error_message = %ErrorMessage
@onready var tooltip_panel:PanelContainer = %TooltipPanel
@onready var tooltip_label:Label = %TooltipLabel
@onready var plant_buttons_container = %PlantButtonsContainer
@onready var level_title:Label = %LevelTitle
@onready var level_description:Label = %LevelDescription
@onready var next_level_button = %WinScreen/MarginContainer/VBoxContainer/NextLevelButton

func _ready():
	# Hide win screen initially
	if win_screen:
		win_screen.hide()
	
	# Connect restart button
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	
	# Connect restart level button
	if restart_level_button:
		restart_level_button.pressed.connect(_on_restart_level_button_pressed)
	
	# Connect next level button
	if next_level_button:
		next_level_button.pressed.connect(_on_next_level_button_pressed)
	
	# Connect plant buttons
	for plant_button:PlantButton in plant_buttons_container.get_children():
		plant_button.pressed.connect(_on_plant_button_pressed.bind(plant_button.plant_id))
	
	# Connect to game manager signals
	if GameManager.game_won.connect(_on_game_won) != OK:
		push_error("Failed to connect to GameManager.game_won signal")
	
	# Optional: Connect tooltip signals
	_setup_tooltips()

func _on_plant_button_pressed(plant_id: String):
	plant_selected.emit(plant_id)

func _on_game_won():
	if win_screen:
		win_screen.show()

func _on_restart_button_pressed() -> void:
	GameManager.reset_game()
	get_tree().reload_current_scene()

func _on_restart_level_button_pressed() -> void:
	# Reload the current level without resetting progress
	if GameManager.current_level:
		GameManager.load_level(GameManager.current_level_index)

func _on_next_level_button_pressed() -> void:
	if win_screen:
		win_screen.hide()
	GameManager.next_level()

func set_available_plants(available_plant_ids: Array[String]) -> void:
	# Enable/disable plant buttons based on available plants
	for plant_button:PlantButton in plant_buttons_container.get_children():
		if plant_button:
			plant_button.visible = plant_button.plant_id in available_plant_ids

func show_level_info(title: String, description: String) -> void:
	if level_title:
		level_title.text = title
	if level_description:
		level_description.text = description

func show_error_message(message: String, duration: float = 1.5):
	if error_message:
		error_message.text = message
		error_message.show()
		
		# Create a tween to fade out and hide the message
		var tween = create_tween()
		tween.tween_interval(duration)
		tween.tween_property(error_message, "modulate:a", 0.0, 0.3)
		tween.tween_callback(func(): 
			error_message.hide()
			error_message.modulate.a = 1.0
		)

# Optional tooltip management
func _setup_tooltips():
	var tooltip_data = {
		"aqua_pod": "A water-loving plant that thrives in moist environments",
		"sun_petal": "A hardy plant that gives sunlight and excels in mineral-rich soil",
		"aqua_root": "A root plant that absorbs water efficiently",
		"terra_root": "A root plant that draws minerals from the soil",
		"aero_root": "A root plant that absorbs nutrients from the air"
	}
	
	for plant_button:PlantButton in plant_buttons_container.get_children():
		if plant_button:
			plant_button.mouse_entered.connect(_on_plant_button_mouse_entered.bind(tooltip_data[plant_button.plant_id]))
			plant_button.mouse_exited.connect(_on_plant_button_mouse_exited)

func _on_plant_button_mouse_entered(tooltip_text: String):
	if tooltip_label:
		tooltip_label.text = tooltip_text
		tooltip_label.show()


	# Assuming you have a tooltip label node
	#if tooltip_panel:
		#tooltip_panel.position = get_viewport().get_mouse_position() + Vector2(10, 10)
		#tooltip_label.text = tooltip_text
		#tooltip_panel.show()

func _on_plant_button_mouse_exited():
	if tooltip_label:
		tooltip_label.hide()

	#if tooltip_panel:
		#tooltip_panel.hide()
