extends TextureRect
@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var map_thumbnail: TextureRect = $MapThumbnail

@export var unhovered_texture: Texture2D
@export var hovered_texture: Texture2D

func _ready() -> void:
	if !button:
		printerr("Can't find button for ButtonOutline: " + name)
	else:
		if button.is_hovered():
			set_texture(hovered_texture)
		else:
			set_texture(unhovered_texture)
		button.mouse_entered.connect(set_texture.bind(hovered_texture))
		button.mouse_exited.connect(set_texture.bind(unhovered_texture))
