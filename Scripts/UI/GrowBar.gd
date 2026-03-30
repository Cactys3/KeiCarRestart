extends VBoxContainer
class_name GrowBar
@onready var top_offset: Control = $TopOffset
@onready var offsets_x: HBoxContainer = $Offsets_X
@onready var left_offset: Control = $Offsets_X/LeftOffset
@onready var bar_parent: Control = $Offsets_X/BarParent
@onready var bar_background: HBoxContainer = $Offsets_X/BarParent/BarBackground
@onready var background_left: TextureRect = $Offsets_X/BarParent/BarBackground/BackgroundLeft
@onready var background_middle: Panel = $Offsets_X/BarParent/BarBackground/BackgroundMiddle
@onready var background_right: TextureRect = $Offsets_X/BarParent/BarBackground/BackgroundRight
@onready var bar_foreground: HBoxContainer = $Offsets_X/BarParent/BarForeground
@onready var foreground_left_offset: Control = $Offsets_X/BarParent/BarForeground/ForegroundLeftOffset
@onready var foreground_left: TextureRect = $Offsets_X/BarParent/BarForeground/ForegroundLeft
@onready var foreground_middle: Panel = $Offsets_X/BarParent/BarForeground/ForegroundMiddle
@onready var foreground_right: TextureRect = $Offsets_X/BarParent/BarForeground/ForegroundRight
@onready var foreground_right_offset: Control = $Offsets_X/BarParent/BarForeground/ForegroundRightOffset
@onready var right_offset: Control = $Offsets_X/RightOffset
@onready var bottom_offset: Control = $BottomOffset

## Only displays foreground (so can't see how far we are from a full bar)
@export var no_background: bool = false
## Should the bar expand upon being given a value larger than max_value
@export var expand_bar: bool = false
@export_subgroup("Values")
@export var start_max: float = 100
@export var start_value: float = 0
@export_subgroup("Sizes (at 1080p)")
@export var background_height: float = 40
@export var foreground_height: float = 40
@export var min_width: float = 1920
@export_subgroup("Colors")
@export var foreground_color: Color = Color.hex(0x5fcde4) 
@export var background_color: Color = Color.hex(0x222034) 
@export_subgroup("Offsets")
@export var top_offset_height: float = 5
@export var bottom_offset_height: float = 5
@export var left_offset_width: float = 5
@export var right_offset_width: float = 5
@export var foreground_left_offset_width: float = 5
@export var foreground_right_offset_width: float = 5
var max_value: float = 100
func _ready() -> void:
	if no_background:
		bar_background.visible = false
	## Set Values
	set_value(start_value)
	set_max(start_max)
	## Sizes
	bar_background.custom_minimum_size.y = background_height
	bar_foreground.custom_minimum_size.y = foreground_height
	## Set Colors
	bar_background.modulate = background_color
	bar_foreground.modulate = foreground_color
	## Set Offsets
	top_offset.custom_minimum_size.y = top_offset_height
	bottom_offset.custom_minimum_size.y = bottom_offset_height
	left_offset.custom_minimum_size.x = left_offset_width
	right_offset.custom_minimum_size.x = right_offset_width
## Sets the foreground size to value (expands if valid)
func set_value(value: float) -> void:
	## If value is maxxed out
	if value >= max_value:
		if expand_bar:
			print("Expanding bar, ", value)
			set_max(value)
			foreground_middle.custom_minimum_size.x = value
			foreground_middle.size.x = value
			foreground_middle.visible = false
		else:
			print("Maxxed Out, ", value)
			## If Value can go above max without expanding, consider changing the color for the 'above-max' portion
			foreground_middle.custom_minimum_size.x = max_value
			foreground_middle.size.x = max_value
			foreground_middle.visible = false
	## If value is 0
	elif value <= 0.0:
		print("Less 0, ", value)
		foreground_middle.visible = false
	## If value is not special case
	else:
		foreground_middle.custom_minimum_size.x = value * 1000
		foreground_middle.size.x = value
		foreground_middle.visible = false
		print("Normal Value ", value, ", ", foreground_middle.size.x)
## Sets the background value and max value to given value
func set_max(value: float) -> void:
	if value >= 0:
		max_value = value
		background_middle.custom_minimum_size.x = value
		background_middle.size.x = value
	else:
		printerr("trying to set max_width lower than 1")
