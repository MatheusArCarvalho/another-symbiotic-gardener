extends Node

signal grid_updated
signal game_won

# Grid boundaries
const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 10

# Stores plant instances by their grid coordinates
var plant_grid: Dictionary = {}

# Direction vectors for neighbor checking (8-way neighbors)
const NEIGHBOR_DIRECTIONS: Array[Vector2i] = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0),                    Vector2i(1, 0),
	Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
]

func is_tile_empty(grid_coords: Vector2i) -> bool:
	return not plant_grid.has(grid_coords)

func is_valid_coords(grid_coords: Vector2i) -> bool:
	return grid_coords.x >= 0 and grid_coords.x < GRID_WIDTH and \
		   grid_coords.y >= 0 and grid_coords.y < GRID_HEIGHT

func register_plant(plant_instance: Node, grid_coords: Vector2i) -> void:
	if not is_valid_coords(grid_coords):
		push_error("Attempted to place plant outside grid bounds: ", grid_coords)
		return
	
	if not is_tile_empty(grid_coords):
		push_error("Attempted to place plant on occupied tile: ", grid_coords)
		return
	
	plant_grid[grid_coords] = plant_instance

func get_neighbors(grid_coords: Vector2i) -> Array[Plant]:
	var neighbors: Array[Plant] = []
	
	for direction in NEIGHBOR_DIRECTIONS:
		var neighbor_pos = grid_coords + direction
		if is_valid_coords(neighbor_pos) and plant_grid.has(neighbor_pos):
			var neighbor = plant_grid[neighbor_pos]
			if neighbor is Plant:  # Type check to ensure we only get Plant instances
				neighbors.append(neighbor)
	
	return neighbors

func update_entire_grid_state() -> void:
	# First pass: Collect all plants and their neighbors
	var updates: Array[Dictionary] = []
	for grid_coords in plant_grid:
		var plant = plant_grid[grid_coords]
		if plant is Plant:
			var neighbors = get_neighbors(grid_coords)
			updates.append({
				"plant": plant,
				"neighbors": neighbors
			})
	
	# Second pass: Update all plants with their neighbors
	for update in updates:
		update.plant.update_symbiosis(update.neighbors)
	
	grid_updated.emit()
	
	# Check win condition after grid update
	if check_win_condition():
		game_won.emit()

func check_win_condition() -> bool:
	# If there are no plants, we haven't won
	if plant_grid.is_empty():
		return false
	
	# Check if all plants are thriving
	for grid_coords in plant_grid:
		var plant = plant_grid[grid_coords]
		if not plant is Plant or not plant.is_thriving:
			return false
	
	return true

func clear_grid() -> void:
	# Optional: Clean up plant instances if needed
	for coords in plant_grid:
		var plant = plant_grid[coords]
		if is_instance_valid(plant):
			plant.queue_free()
	
	plant_grid.clear()
	grid_updated.emit()