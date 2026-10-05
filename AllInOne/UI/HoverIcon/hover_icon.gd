extends TextureRect
@onready var label_background: TextureRect = $LabelBackground
@onready var label: Label = $LabelBackground/Label
@onready var button: Button = $Button
@onready var inside_rect: TextureRect = $InsideRect
@export_multiline ("Leave Blank For Nothing") var custom_text_on_hover: String = ""
@export var custom_text_label_settings: LabelSettings = null
## If false, it offsets left
@export var text_offsets_right: bool = false
@export var text_self_modulate: Color = Color.TRANSPARENT
@export var text_self_modulate_strength: float = 0.3
@export var text_background: Texture2D
@export var keep_text_on_hold_press: bool = false

## Outside Textures
@export var border_self_modulate: Color = Color.TRANSPARENT
@export var border_self_modulate_strength: float = 0.5
@export var standard_border: Texture2D
@export var hover_border: Texture2D
@export var pressed_border: Texture2D
## Inside Textures
@export var texture_self_modulate: Color = Color.TRANSPARENT
@export var texture_self_modulate_strength: float = 0.5
@export var standard_texture: Texture2D
@export var hover_texture: Texture2D
@export var pressed_texture: Texture2D

var showing_hover_ui: bool = false
var pressing: bool = false
var hovering: bool = false

func _process(delta: float) -> void:
	if showing_hover_ui:
		## TODO: Implement hiding mouse and putting graphic right on top of mouse instead of offset?
		label_background.global_position = label_background.global_position.lerp(get_label_position(), delta * 20) 
func _ready() -> void:
	label_background.visible = false
	label.text = ""
	if text_background != null:
		label_background.texture = text_background
	if custom_text_label_settings != null:
		label.label_settings = custom_text_label_settings
	if texture_self_modulate != Color.TRANSPARENT:
		inside_rect.self_modulate = Color.WHITE.lerp(texture_self_modulate, texture_self_modulate_strength)
	if border_self_modulate != Color.TRANSPARENT:
		self_modulate = Color.WHITE.lerp(border_self_modulate, border_self_modulate_strength)
	if text_self_modulate != Color.TRANSPARENT:
		label.self_modulate = Color.WHITE.lerp(text_self_modulate, text_self_modulate_strength)
	texture = null
	inside_rect.texture = null
	if is_hovered():
		set_hovered()
	else:
		set_standard()
	button.mouse_entered.connect(set_hovered)
	button.mouse_exited.connect(set_standard)
	button.button_down.connect(set_pressed)
	button.button_up.connect(release_press)
func pressed():
	pressing = true
func hover(value: bool):
	if !showing_hover_ui:
		create_hover_ui()
	if pressing:
		return
	if !value:
		texture = standard_texture
	else:
		texture = hover_texture
func press(value: bool):
	if pressed_texture:
		if value:
			pressing = true
			set_pressed()
		else:
			pressing = false
			if is_hovered():
				set_hovered()
			else:
				set_standard()
func release_press():
	pressing = false
	if showing_hover_ui && !hovering:
		kill_hover_ui()
	## Set Standard first as a fallback in case hovered textures don't exist
	set_standard()
	if is_hovered():
		set_hovered()
func set_pressed():
	pressing = true
	if pressed_border:
		set_texture(pressed_border)
	if pressed_texture:
		inside_rect.set_texture(pressed_texture)
func set_hovered():
	if pressing:
		return
	if !showing_hover_ui:
		create_hover_ui()
	if hover_border:
		set_texture(hover_border)
	if hover_texture:
		inside_rect.set_texture(hover_texture)
func set_standard():
	if showing_hover_ui && (!keep_text_on_hold_press || !pressing):
		kill_hover_ui()
	if pressing:
		return
	if standard_border:
		set_texture(standard_border)
	if standard_texture:
		inside_rect.set_texture(standard_texture)
## Helper to check if mouse is over this rect
func is_hovered() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())
func create_hover_ui():
	showing_hover_ui = true
	label.size = Vector2.ZERO
	label.text = custom_text_on_hover
	label_background.global_position = get_global_mouse_position() - Vector2(0, label_background.size.y / 2)
	label_background.visible = true
func kill_hover_ui():
	showing_hover_ui = false
	label.text = ""
	label_background.visible = false
func get_label_position() -> Vector2:
	## TODO: Implement hiding mouse and putting graphic right on top of mouse instead of offset?
	var offset: Vector2 
	if text_offsets_right:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		offset = Vector2(max(label_background.size.x, label.size.x) * -1, label_background.size.y / 2)
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		offset = Vector2(max(label_background.size.x, label.size.x) * 0.5, label_background.size.y / 2)
	return get_global_mouse_position() - offset
