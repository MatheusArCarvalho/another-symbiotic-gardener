extends Node2D

# Reference to other nodes
@onready var ui = $UI
@onready var grid = $Grid

# Plant scene cache to avoid repeated loading
@export var plant_scenes: Dictionary[String, PackedScene] = {}
var current_selected_plant_type: String = ""

func _ready() -> void:
	# Connect signals
	if ui.plant_selected.connect(_on_plant_selected) != OK:
		push_error("Failed to connect UI plant_selected signal")
	
	if grid.tile_clicked.connect(_on_tile_clicked) != OK:
		push_error("Failed to connect Grid tile_clicked signal")


func _on_plant_selected(plant_type: String) -> void:
	current_selected_plant_type = plant_type


func _on_tile_clicked(grid_coords: Vector2i) -> void:
	# No plant type selected
	if current_selected_plant_type.is_empty():
		ui.show_error_message("Select a plant first!", 1.5)
		return
	
	# Check if move is valid
	if not GameManager.is_tile_empty(grid_coords):
		_handle_invalid_placement(grid_coords)
		return
	
	# Get plant scene from cache
	var plant_scene = plant_scenes.get(current_selected_plant_type)
	if not plant_scene:
		push_error("Plant scene not found: " + current_selected_plant_type)
		return
	
	# Instantiate and place the plant
	var plant_instance = plant_scene.instantiate()
	if not plant_instance:
		push_error("Failed to instantiate plant: " + current_selected_plant_type)
		return
	
	# Add plant both visually and logically
	grid.add_plant_to_tile(plant_instance, grid_coords)
	GameManager.register_plant(plant_instance, grid_coords)
	
	# Trigger resolve step
	GameManager.update_entire_grid_state()

func _handle_invalid_placement(grid_coords: Vector2i) -> void:
	# Show visual feedback for invalid placement
	ui.show_error_message("Tile Occupied!", 1.5)
	print("Cannot place plant at ", grid_coords, " - tile is occupied")
