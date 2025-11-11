@tool
class_name PlantButton
extends Button

@export var plant_id: String = ""

@onready var label: Label = $Label


func _ready() -> void:
    label.text = plant_id.capitalize().replace("_", " ")


