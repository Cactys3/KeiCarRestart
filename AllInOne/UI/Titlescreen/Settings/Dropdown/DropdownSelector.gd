extends TextureRect
class_name DropdownSelector
@onready var label: Label = $Label

const DROPDOWN_OPTION = preload("uid://8vxefhf8mbw0")

var options: Array[DropdownOption]
var hovering: bool = false
var selected: bool = false
var controller

func setup(parent, starting_option: String, option_names: Array[String]):
	print("setup")
	controller = parent
	label.text = "Click to Select"
	for option_name in option_names:
		print("What Up: ", option_name)
		var option: DropdownOption = DROPDOWN_OPTION.instantiate()
		option.option_name = option_name
		options.append(option)
		add_child(option)
		if option_name == starting_option:
			label.text = starting_option
	for option in options:
		print("Yo where the fucking options at???")
		option.visible = false
		option.selector = self
		option.active = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("M1"):
		if !selected:
			if is_hovered():
				select()
		else:
			if !is_hovered():
				unselect()

const x_offset: float = 136.0  # 128 parent width + 8 gap
const y_offset: float = 76.0   # 68 option height + 8 gap
func select():
	selected = true
	show_options()
func unselect():
	selected = false
	call_deferred("hide_options")
func show_options():
	var offset: Vector2 = Vector2(x_offset, (options.size() - 1) * -(y_offset / 2))
	for option in options:
		option.target_position = offset
		option.global_position = global_position
		option.active = true
		option.selectable = false
		option.moving = true
		option.visible = true
		set_selectable(option)
		offset += Vector2(0, y_offset)
func hide_options():
	for option in options:
		option.active = false
		option.visible = false
		option.target_position = Vector2.ZERO

func set_selectable(option: DropdownOption):
	await get_tree().process_frame
	option.selectable = true
func option_selected(option: String):
	label.text = option
	controller.dropdown_selected(self, option)
	## Disable other options so we don't double-proc
	for curr_option in options:
		curr_option.active = false
func is_hovered() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())
