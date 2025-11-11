@tool
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

func generate_grid() -> void:
	for x in range(grid_width):
		for y in range(grid_height):
			var tile = tile_scene.instantiate()
			var grid_coords = Vector2i(x, y)
			
			# Set position and grid coordinates
			tile.position = Vector2(x * tile_size, y * tile_size)
			tile.grid_coords = grid_coords
			add_child(tile)
			
			# Store tile reference
			tiles[grid_coords] = tile
			
			# Connect tile's clicked signal
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