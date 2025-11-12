@tool
class_name Grid
extends Node2D

signal tile_clicked(grid_coords: Vector2i)

@export var tile_scene: PackedScene
@export var grid_width: int = 10
@export var grid_height: int = 10
@export var tile_size: int = 64

# Dictionary to store tile instances
var tiles: Dictionary = {}

func _ready() -> void:
	generate_grid()

func clear_grid() -> void:
	# Remove all existing tiles
	for tile in tiles.values():
		if is_instance_valid(tile):
			tile.queue_free()
	tiles.clear()

func generate_grid() -> void:
	# Clear existing grid first
	clear_grid()
	
	for x in range(grid_width):
		for y in range(grid_height):
			var tile = tile_scene.instantiate()
			var grid_coords = Vector2i(x, y)
			
			# Set position
			tile.position = Vector2(x * tile_size, y * tile_size)
			add_child(tile)
			
			# Set grid coordinates after adding to tree
			if tile.has_method("set") and "grid_coords" in tile:
				tile.grid_coords = grid_coords
			
			# Store tile reference
			tiles[grid_coords] = tile
			
			# Connect tile's clicked signal
			if tile.has_signal("tile_clicked"):
				tile.tile_clicked.connect(_on_tile_clicked)

func _on_tile_clicked(grid_coords: Vector2i) -> void:
	tile_clicked.emit(grid_coords)

func add_plant_to_tile(plant_instance: Node, grid_coords: Vector2i, plants_container: Node2D) -> void:
	if grid_coords in tiles:
		var tile = tiles[grid_coords]
		var marker = tile.get_node("Marker2D")
		
		# Add plant to the PlantsContainer
		plants_container.add_child(plant_instance)
		
		# Set plant's global position to the marker's global position
		plant_instance.global_position = marker.global_position