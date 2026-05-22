extends Control
class_name GrowBar
@onready var top_offset: Control = $TopOffset
@onready var offsets_x: HBoxContainer = $Offsets_X
@onready var left_offset: Control = $Offsets_X/LeftOffset
@onready var bar_parent: Control = $Offsets_X/BarParent
@onready var bar_background: HBoxContainer = $Offsets_X/BarParent/BarBackground
@onready var background_left_image: TextureRect = $Offsets_X/BarParent/BarBackground/BackgroundLeftImage
@onready var background_middle: Panel = $Offsets_X/BarParent/BarBackground/BackgroundMiddle
@onready var background_right_image: TextureRect = $Offsets_X/BarParent/BarBackground/BackgroundRightImage
@onready var bar_foreground: HBoxContainer = $Offsets_X/BarParent/BarForeground
@onready var foreground_left_offset: Control = $Offsets_X/BarParent/BarForeground/ForegroundLeftOffset
@onready var foreground_left_image: TextureRect = $Offsets_X/BarParent/BarForeground/ForegroundLeftImage
@onready var foreground_middle: Panel = $Offsets_X/BarParent/BarForeground/ForegroundMiddle
@onready var foreground_right_image: TextureRect = $Offsets_X/BarParent/BarForeground/ForegroundRightImage
@onready var foreground_right_offset: Control = $Offsets_X/BarParent/BarForeground/ForegroundRightOffset
@onready var right_offset: Control = $Offsets_X/RightOffset
@onready var bottom_offset: Control = $BottomOffset

## Only displays foreground (so can't see how far we are from a full bar)
var old_version_toggle: bool = false
@export var no_background: bool = false
## Should the bar expand upon being given a value larger than max_value
@export var expand_bar: bool = false
@export var expand_bar_without_raising_max: bool = false
@export var reset_on_full: bool = false
@export_subgroup("Values")
## Multiplied to inputted values to transform them to size values
@export var value_multiplier: float = 1
@export var start_max: float = 100
@export var start_value: float = 0
@export_subgroup("Colors")
@export var foreground_color: Color = Color.hex(0x5fcde4) 
@export var background_color: Color = Color.hex(0x222034) 
@export_subgroup("Sizes (at 1080p)")
## If false, won't use the below values
@export var use_custom_sizes: bool = true
@export var background_height: float = 40
@export var foreground_height: float = 40
@export var min_width: float = 1920
@export var top_offset_height: float = 5
@export var bottom_offset_height: float = 5
@export var left_offset_width: float = 10
@export var right_offset_width: float = 10
@export var foreground_left_offset_width: float = 5
@export var foreground_right_offset_width: float = 5
var max_value: float = 0
var curr_value: float = 0
func _ready() -> void:
	if no_background:
		bar_background.visible = false
	if use_custom_sizes:
		## Sizes
		bar_background.custom_minimum_size.y = background_height
		bar_foreground.custom_minimum_size.y = foreground_height
		bar_background.size.y = background_height
		bar_foreground.size.y = foreground_height
		## Set Offsets
		top_offset.custom_minimum_size.y = top_offset_height
		bottom_offset.custom_minimum_size.y = bottom_offset_height
		left_offset.custom_minimum_size.x = left_offset_width
		right_offset.custom_minimum_size.x = right_offset_width
	## Set Colors
	bar_background.modulate = background_color
	bar_foreground.modulate = foreground_color
	## Set Values
	set_value(start_value)
	set_max(start_max)
func _process(delta: float) -> void:
	## Make sure sizes are correct
	if bar_background.size.x != max_value:
		bar_background.custom_minimum_size.x = max_value
		bar_background.size.x = max_value
	if bar_foreground.size.x != curr_value:
		bar_foreground.custom_minimum_size.x = curr_value
		bar_foreground.size.x = curr_value
	#if !old_version_toggle:
		### Make sure sizes are correct
		#if bar_background.size.x != max_value:
			#bar_background.custom_minimum_size.x = max_value
			#bar_background.size.x = max_value
		#if bar_foreground.size.x != curr_value:
			#bar_foreground.custom_minimum_size.x = curr_value
			#bar_foreground.size.x = curr_value
	#else:
		#if background_middle.size.x != max_value:
			#background_middle.custom_minimum_size.x = max_value
			#background_middle.size.x = max_value
		#if foreground_middle.size.x != curr_value:
			#foreground_middle.custom_minimum_size.x = curr_value
			#foreground_middle.size.x = curr_value
## Sets the foreground size to value (expands if valid)
func set_value(value: float) -> void:
	value = value * value_multiplier
	#print("set Value")
	## If value is maxxed out
	if value >= max_value:
		reset_foreground()
		if reset_on_full:
			#print("Less 0, ", max_value)
			_set_width(max_value, false)
		else:
			if expand_bar || expand_bar_without_raising_max:
				if expand_bar:
					## Only raise max with expand_bar
					set_max(value)
				_set_width(value, true)
			else:
				#print("Maxxed Out, ", value, ", ", foreground_middle.size.x, ", ", bar_background.size.x)
				## If Value can go above max without expanding, consider changing the color for the 'above-max' portion
				_set_width(max_value, true)
				#print("value maxxed, ", value, " max: ", max_value, " wdith, ", foreground_middle.size.x)
	## If value is 0
	elif value <= 0.0:
		#print("Less 0, ", value)
		reset_foreground()
		_set_width(0, false)
	## If value is not special case
	else:
		_set_width(value, true)
		#print("Normal Value ", value, ", ", foreground_middle.size.x)
## Sets the foreground size to percent value
func set_value_percent(percent: float) -> void:
	#print("set Value")
	## If value is maxxed out
	if percent >= 1:
		if reset_on_full:
			_set_width(max_value, false)
		else:
			if expand_bar || expand_bar_without_raising_max:
				if expand_bar:
					## Only raise max with expand_bar
					set_max(percent * max_value)
				_set_width(max_value, true)
			else:
				#print("Maxxed Out, ", value, ", ", bar_foreground.size.x, ", ", bar_background.size.x)
				## If Value can go above max without expanding, consider changing the color for the 'above-max' portion
				_set_width(max_value, true)
	## If value is 0
	elif percent <= 0.0:
		#print("Less 0, ", value)
		_set_width(0, false)
	## If value is not special case
	else:
		_set_width(min(max_value * percent, max_value), true)
		#print("Normal Value ", value, ", ", bar_foreground.size.x)
## Sets the background value and max value to given value
func set_max(value: float) -> void:
	value = value * value_multiplier
	if value >= 0:
		_set_max_width(value)
	else:
		printerr("trying to set max_width lower than 1")
func _set_max_width(value: float):
	max_value = value
	if old_version_toggle:
		## Sets the background-parent, overall bar width (instead of bar-middle)
		bar_background.custom_minimum_size.x = value 
		bar_background.size.x = value
	else:
		## Sets the background-middle, inside bar width (instead of bar parent)
		background_middle.custom_minimum_size.x = value 
		background_middle.size.x = value
## Internal function that sets the width of the bar, and visibility
func _set_width(value: float, visible_value: bool) -> void:
	curr_value = value
	set_foreground_visible(visible_value)
	if old_version_toggle:
		## Sets the foreground-parent, overall bar width (instead of bar-middle)
		bar_foreground.custom_minimum_size.x = value 
		bar_foreground.size.x = value
	else:
		## Sets the foreground-middle, inside bar width (instead of bar parent)
		foreground_middle.custom_minimum_size.x = value 
		foreground_middle.size.x = value
func set_foreground_visible(value: bool) -> void:
	bar_foreground.visible = value
## Old version that stretches left/right images
func set_value_funky_implementation(value: float) -> void:
	value = value * value_multiplier
	#print("set Value")
	## If value is maxxed out
	if value >= max_value:
		reset_foreground()
		if reset_on_full:
			#print("Less 0, ", value)
			_set_width(max_value, false)
		else:
			if expand_bar:
				#print("Expanding bar, ", value)
				set_max(value)
				_set_width(value, true)
			else:
				#print("Maxxed Out, ", value, ", ", bar_foreground.size.x, ", ", bar_background.size.x)
				## If Value can go above max without expanding, consider changing the color for the 'above-max' portion
				_set_width(max_value, true)
	## If value is 0
	elif value <= 0.0:
		#print("Less 0, ", value)
		reset_foreground()
		_set_width(0, false)
	## If value is not special case
	else:
		_set_width(value, true)
		## If middle of bar is 0 width, check if we should visible = false the side images yet
		if foreground_middle.size.x <= 0:
			#print("Middle is zero, ", foreground_middle.size.x )
			if value >= foreground_right_image.size.x + foreground_left_image.size.x:
				#print("Bar: ", value, " vs ", foreground_right_image.size.x + (foreground_left_image.size.x / 2))
				## Bigger than both images
				#foreground_left_image.visible = true
				reset_foreground()
			elif value >= foreground_right_image.size.x:
				#print("elif: ", value, " >= ", foreground_right_image.size.x)
				## Bigger than one image
				#foreground_right_image.visible = false
				foreground_right_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				foreground_left_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			else:
				## Smaller than one image
				#print("else: ", value, " >= ", foreground_right_image.size.x)
				#foreground_right_image.visible = false
				foreground_right_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				foreground_left_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		## Try again
		_set_width(value, true)
		#print("Normal Value ", value, ", ", bar_foreground.size.x)
func reset_foreground():
	foreground_right_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	foreground_left_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
