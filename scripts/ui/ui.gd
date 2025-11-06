extends CanvasLayer

signal plant_selected(plant_type_id: String)

@onready var win_screen = $WinScreen
@onready var plant_buttons = {
	"aqua_root": $PlantButtons/AquaRoot,
	"terra_root": $PlantButtons/TerraRoot,
	"aero_root": $PlantButtons/AeroRoot
}

func _ready():
	# Hide win screen initially
	if win_screen:
		win_screen.hide()
	
	# Connect plant buttons
	for plant_id in plant_buttons:
		if plant_buttons[plant_id]:
			plant_buttons[plant_id].pressed.connect(_on_plant_button_pressed.bind(plant_id))
	
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
		"aqua_root": "A water-loving plant that thrives in moist environments",
		"terra_root": "A hardy plant that excels in mineral-rich soil",
		"aero_root": "A plant that prefers open spaces and good airflow"
	}
	
	for plant_id in plant_buttons:
		if plant_buttons[plant_id]:
			var button = plant_buttons[plant_id]
			button.mouse_entered.connect(_on_button_mouse_entered.bind(tooltip_data[plant_id]))
			button.mouse_exited.connect(_on_button_mouse_exited)

func _on_button_mouse_entered(tooltip_text: String):
	# Assuming you have a tooltip label node
	if $TooltipLabel:
		$TooltipLabel.text = tooltip_text
		$TooltipLabel.show()

func _on_button_mouse_exited():
	if $TooltipLabel:
		$TooltipLabel.hide()