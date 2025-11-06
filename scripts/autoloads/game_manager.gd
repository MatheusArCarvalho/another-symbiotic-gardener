extends Node

signal grid_updated(new_grid:Dictionary)
signal game_won # Emitted when check_win_condition() passes.

var plant_grid:Dictionary = {}


func register_plant(plant_instance, grid_coords:Vector2) -> void:
    plant_grid[grid_coords] = plant_instance

func get_neighbors(grid_coords:Vector2) -> Array:
    var neighbors = []
    var directions = [
        Vector2(-1, 0), Vector2(1, 0),
        Vector2(0, -1), Vector2(0, 1),
        Vector2(-1, -1), Vector2(1, -1),
        Vector2(-1, 1), Vector2(1, 1)
    ]
    
    for dir in directions:
        var neighbor_pos = grid_coords + dir
        for plant_id in plant_grid.keys():
            if plant_grid[plant_id] == neighbor_pos:
                neighbors.append(plant_id)
    
    return neighbors

func update_entire_grid() -> void:
        for grid_coords in plant_grid.keys():
            var plant = plant_grid[grid_coords]
            if plant:
                var neighbors = get_neighbors(plant_grid[plant_id])
                plant.update_state(neighbors)
        grid_updated.emit(plant_grid)



func check_win_condition() -> bool:
    for plant_id in plant_grid.keys():
        var plant = ObjectDB.instance(plant_id)
        if plant == null:
            return false
        if not plant.is_thriving:
            return false
    # Example win condition: all plants are in a specific configuration
    # This is a placeholder; implement actual logic as needed

    game_won.emit()
    return true