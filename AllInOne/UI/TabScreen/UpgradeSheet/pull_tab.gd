extends TextureRect
@onready var button: Button = $Button
@export var standard_texture: Texture2D
@export var hover_texture: Texture2D

func _ready() -> void:
	if get_parent().has_method("_pull_tab_pressed"):
		button.pressed.connect(pressed)
	button.mouse_entered.connect(hover.bind(true))
	button.mouse_exited.connect(hover.bind(false))
func pressed():
	get_parent()._pull_tab_pressed()
func hover(value: bool):
	if !value:
		texture = standard_texture
	else:
		texture = hover_texture
