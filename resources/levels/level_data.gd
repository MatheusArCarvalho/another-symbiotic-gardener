class_name LevelData
extends Resource

## Represents a single level configuration

@export var level_id: int = 0
@export var level_name: String = ""
@export_multiline var level_description: String = ""

## Pre-placed plants: Dictionary[Vector2i, String] where String is plant_id
@export var pre_placed_plants: Dictionary = {}

## Available plants the player can use
@export var available_plants: Array[String] = []

## Optional: Specific tiles that must be filled (if empty, any configuration that makes all plants thrive wins)
@export var required_filled_tiles: Array[Vector2i] = []

## Optional: Maximum number of plants the player can place
@export var max_player_plants: int = -1  # -1 means unlimited
