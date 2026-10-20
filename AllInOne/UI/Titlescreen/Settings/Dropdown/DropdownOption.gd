extends TextureRect
class_name DropdownOption
@onready var label: Label = $Label
@export var option_name: String = "unset"
var target_position: Vector2 = Vector2.ZERO
var active: bool = false
var moving: bool = false
var selectable: bool = false
var selector
func _ready() -> void:
	label.text = option_name
func _process(delta: float) -> void:
	if active:
		if moving:
			if target_position != position:
				position = position.lerp(target_position, delta * 10)
				if position.distance_to(target_position) < 0.5: 
					position = target_position
				mouse_filter = Control.MOUSE_FILTER_IGNORE
			else:
				moving = false
				mouse_filter = Control.MOUSE_FILTER_STOP
		if selectable && Input.is_action_just_pressed("M1") && get_global_rect().has_point(get_global_mouse_position()):
			if selector:
				selector.option_selected(option_name)
			else:
				printerr("Selector not set")
