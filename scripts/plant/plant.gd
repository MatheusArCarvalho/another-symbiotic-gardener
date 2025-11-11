extends Node2D
class_name Plant

@export var plant_id: String
@export var plant_name: String
@export var provides: Array[String] = []
@export var needs: Array[String] = []

@onready var sprite: Sprite2D = $Sprite2D

var is_thriving: bool = false:
	set = _set_thriving_visuals,
	get = _get_thriving

func _ready():
	# Initialize visual state
	_set_thriving_visuals(is_thriving)

func update_symbiosis(neighbor_plants: Array[Plant]) -> void:
	var met_needs = []
	
	# Check each need against all neighbor plants
	for need in needs:
		for neighbor in neighbor_plants:
			if neighbor.provides.has(need):
				met_needs.append(need)
				break
	
	# Plant is thriving if all needs are met
	is_thriving = met_needs.size() == needs.size()

func _set_thriving_visuals(new_value: bool) -> void:
	is_thriving = new_value
	
	if not sprite:
		return
	
	if is_thriving:
		sprite.modulate = Color(1, 1, 1, 1)  # Normal color
		sprite.scale = Vector2(1.1, 1.1)     # Slightly larger
	else:
		sprite.modulate = Color(0.7, 0.7, 0.7, 1)  # Darker/desaturated
		sprite.scale = Vector2(1.0, 1.0)           # Normal size
	
	# Optional: You could add animation here
	# var tween = create_tween()
	# tween.tween_property(sprite, "scale", target_scale, 0.3)

func _get_thriving() -> bool:
	return is_thriving
