extends PanelContainer

@onready var label: Label = $Label

func set_tooltip_label_text(text: String) -> void:
	label.text = text
