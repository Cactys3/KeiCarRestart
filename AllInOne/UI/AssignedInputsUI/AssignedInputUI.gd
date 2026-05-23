extends VBoxContainer
class_name AssignedInputUI
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect
var slot: int = -1
func setup(texture: Texture2D, input_name: String, new_slot: int):
	slot = new_slot
	label.text = input_name
	texture_rect.texture = texture
