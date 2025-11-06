extends Area2D

signal tile_clicked(grid_coords: Vector2i)

var grid_coords: Vector2i

func _ready():
	# Connect the input event signal
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Check for left mouse button click
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed:
		tile_clicked.emit(grid_coords)
