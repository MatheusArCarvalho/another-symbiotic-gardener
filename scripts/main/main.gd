extends Node2D

# Reference to other nodes
@onready var ui = $UI
@onready var grid = $Grid
@onready var plants_container = $PlantsContainer

# Plant scene cache to avoid repeated loading
@export var plant_scenes: Dictionary[String, PackedScene] = {}
var current_selected_plant_type: String = ""

func _ready() -> void:
	# Connect signals
	if ui.plant_selected.connect(_on_plant_selected) != OK:
		push_error("Failed to connect UI plant_selected signal")
	
	if grid.tile_clicked.connect(_on_tile_clicked) != OK:
		push_error("Failed to connect Grid tile_clicked signal")
	
	if GameManager.level_loaded.connect(_on_level_loaded) != OK:
		push_error("Failed to connect GameManager level_loaded signal")
	
	if GameManager.game_won.connect(_on_level_won) != OK:
		push_error("Failed to connect GameManager game_won signal")
	
	# Load first level
	if GameManager.levels.size() > 0:
		print("Loading level 0, total levels: ", GameManager.levels.size())
		GameManager.load_level(0)
	else:
		push_error("No levels found in GameManager!")


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
	
	# Check if player can place more plants
	if not GameManager.can_place_plant():
		ui.show_error_message("Plant limit reached!", 1.5)
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
	grid.add_plant_to_tile(plant_instance, grid_coords, plants_container)
	GameManager.register_plant(plant_instance, grid_coords)
	GameManager.on_player_plant_placed()
	
	# Trigger resolve step
	GameManager.update_entire_grid_state()

func _on_level_loaded(level_data) -> void:
	print("Level loaded: ", level_data.level_name if level_data else "null")
	
	# Clear existing plants
	GameManager.clear_grid()
	
	# Clear visual plants
	for child in plants_container.get_children():
		child.queue_free()
	
	# Update UI with available plants
	print("Available plants: ", level_data.available_plants)
	ui.set_available_plants(level_data.available_plants)
	ui.show_level_info(level_data.level_name, level_data.level_description)
	
	# Wait a frame for the scene tree to update
	await get_tree().process_frame
	
	# Pre-place plants
	print("Pre-placing plants: ", level_data.pre_placed_plants)
	for grid_pos in level_data.pre_placed_plants:
		var plant_id = level_data.pre_placed_plants[grid_pos]
		print("Placing ", plant_id, " at ", grid_pos)
		var plant_scene = plant_scenes.get(plant_id)
		
		if plant_scene:
			var plant_instance = plant_scene.instantiate()
			grid.add_plant_to_tile(plant_instance, grid_pos, plants_container)
			GameManager.register_plant(plant_instance, grid_pos)
		else:
			push_error("Plant scene not found for: ", plant_id)
	
	# Update grid state after pre-placing plants
	GameManager.update_entire_grid_state()

func _on_level_won() -> void:
	print("Level ", GameManager.current_level_index + 1, " completed!")


func _handle_invalid_placement(grid_coords: Vector2i) -> void:
	# Show visual feedback for invalid placement
	ui.show_error_message("Tile Occupied!", 1.5)
	print("Cannot place plant at ", grid_coords, " - tile is occupied")
