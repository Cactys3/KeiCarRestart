extends Control
## Radial Cooldown UI used by Upgrade.gd
class_name CooldownUI
@onready var radial_progress_ui: TextureRect = $RadialProgressUI
@onready var upgrade_thumbnail: TextureRect = $UpgradeThumbnail
@onready var on_hover_text: Label = $OnHoverText
const RADIAL_UI_SPRITEFRAMES = preload("uid://c5asx1s1p354y")
const ANIMATION_NAME: String = "default"
var sprite
var started: bool = false
var text_on_hover: String = "cooldown"
## Color of the radial ui
var color: Color = Color.BLACK
## Thumbnail of the upgrade
var thumbnail: Texture2D
var hovering: bool = false
## Sets up this CooldownUI and returns the Finished Signal
func setup(new_text_on_hover, new_color: Color, new_thumbnail: Texture2D) -> void:
	text_on_hover = new_text_on_hover
	color = new_color
	thumbnail = new_thumbnail
	upgrade_thumbnail.texture = thumbnail
	radial_progress_ui.self_modulate = color
## Percent from 0  to 1
func set_progress(percent: float):
	var frame_index: int = ceil(percent * (RADIAL_UI_SPRITEFRAMES.get_frame_count(ANIMATION_NAME) - 1))
	print(frame_index)
	radial_progress_ui.texture = RADIAL_UI_SPRITEFRAMES.get_frame_texture(ANIMATION_NAME, frame_index)
func kill():
	queue_free()

func _on_mouse_entered() -> void:
	if !hovering:
		hovering = true
		on_hover_text.text = text_on_hover
		on_hover_text.visible = true
func _on_mouse_exited() -> void:
	if hovering:
		hovering = false
		on_hover_text.visible = false
