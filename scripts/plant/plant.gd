extends Node2D
class_name Plant

@export var plant_data: PlantData

@onready var visuals: Node2D = $Visuals

var is_thriving: bool = false:
	set = _set_thriving_visuals,
	get = _get_thriving


func _ready():
	# Initialize visual state
	_set_thriving_visuals(is_thriving)

func update_symbiosis(neighbor_plants: Array[Plant]) -> void:
	var met_needs = []
	
	# Check each need against all neighbor plants
	for need:PlantData.PLANT_RESOURCE_TYPES in plant_data.needs:
		for neighbor in neighbor_plants:
			if neighbor.plant_data.provides.has(need):
				met_needs.append(need)
				break
	
	# Plant is thriving if all needs are met
	is_thriving = met_needs.size() == plant_data.needs.size()

func _set_thriving_visuals(new_value: bool) -> void:
	is_thriving = new_value
	
	if not visuals:
		return
	
	if is_thriving:
		visuals.modulate = Color(1, 1, 1, 1)  # Normal color
		visuals.scale = Vector2(1.1, 1.1)     # Slightly larger
	else:
		visuals.modulate = Color(0.7, 0.7, 0.7, 1)  # Darker/desaturated
		visuals.scale = Vector2(1.0, 1.0)           # Normal size
	
	# Optional: You could add animation here
	# var tween = create_tween()
	# tween.tween_property(sprite, "scale", target_scale, 0.3)

func _get_thriving() -> bool:
	return is_thriving
