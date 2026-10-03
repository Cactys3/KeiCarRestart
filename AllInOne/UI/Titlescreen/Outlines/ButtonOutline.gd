extends TextureRect
var button: Button
@export var unhovered_texture: Texture2D
@export var hovered_texture: Texture2D

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
		button.mouse_entered.connect(set_texture.bind(hovered_texture))
		button.mouse_exited.connect(set_texture.bind(unhovered_texture))
