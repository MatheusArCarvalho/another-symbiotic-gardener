extends Node2D

signal tile_clicked(grid_coords: Vector2i)

@export var tile_scene: PackedScene
@export var grid_width: int = 10
@export var grid_height: int = 10

# Dictionary to store tile instances
var tiles = {}

func _ready():
	generate_grid()

func generate_grid():
	for x in range(grid_width):
		for y in range(grid_height):
			var tile = tile_scene.instantiate()
			tile.position = Vector2(x * 64, y * 64)  # Assuming 64x64 tile size
			add_child(tile)
			
			# Store tile reference
			var grid_coords = Vector2i(x, y)
			tiles[grid_coords] = tile
			
			# Connect tile's clicked signal
			tile.tile_clicked.connect(_on_tile_clicked.bind(grid_coords))

func _on_tile_clicked(grid_coords: Vector2i):
	tile_clicked.emit(grid_coords)

func add_plant_to_tile(plant_instance, grid_coords: Vector2i):
	if grid_coords in tiles:
		tiles[grid_coords].add_child(plant_instance)