extends CanvasLayer

signal plant_selected(plant_type_id: String)

@onready var win_screen = $WinScreen
@onready var tooltip_panel:PanelContainer = $TooltipPanel
@onready var plant_buttons_container = $MarginContainer/PlantButtonsContainer

func _ready():
	# Hide win screen initially
	if win_screen:
		win_screen.hide()
	
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

# Optional tooltip management
func _setup_tooltips():
	var tooltip_data = {
		"aqua_pod": "A water-loving plant that thrives in moist environments",
        "sun_petal": "A hardy plant that gives sunlight and excels in mineral-rich soil"
	}
	
	for plant_button:PlantButton in plant_buttons_container.get_children():
		if plant_button:
			plant_button.mouse_entered.connect(_on_plant_button_mouse_entered.bind(tooltip_data[plant_button.plant_id]))
			plant_button.mouse_exited.connect(_on_plant_button_mouse_exited)

func _on_plant_button_mouse_entered(tooltip_text: String):
	# Assuming you have a tooltip label node
	if tooltip_panel:
		#tooltip_panel.position = get_viewport().get_mouse_position() + Vector2(10, 10)
		tooltip_panel.set_tooltip_label_text(tooltip_text)
		tooltip_panel.show()

func _on_plant_button_mouse_exited():
	if tooltip_panel:
		tooltip_panel.hide()