extends TextureRect
var button: Button

@export var unhovered_texture: Texture2D
@export var hovered_texture: Texture2D
@export var pressed_texture: Texture2D

var pressing = false

func _ready() -> void:
	for child in get_children():
		if child is Button:
			button = child
			break
	if !button:
		printerr("Can't find button for ButtonOutline: " + name)
	else:
		if button.is_hovered():
			set_texture(hovered_texture)
		else:
			set_texture(unhovered_texture)
		button.mouse_entered.connect(hover.bind(true))
		button.mouse_exited.connect(hover.bind(false))
		#button.mouse_entered.connect(set_texture.bind(hovered_texture))
		#button.mouse_exited.connect(set_texture.bind(unhovered_texture))
		button.button_down.connect(press.bind(true))
		button.button_up.connect(press.bind(false))

func press(value: bool):
	if pressed_texture:
		if value:
			pressing = true
			set_texture(pressed_texture)
		else:
			pressing = false
			set_texture(unhovered_texture)

func hover(value: bool):
	if value:
		set_texture(hovered_texture)
	else:
		set_texture(unhovered_texture)
