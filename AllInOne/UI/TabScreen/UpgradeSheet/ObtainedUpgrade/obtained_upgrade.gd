extends TextureRect
@onready var button: Button = $Button
@onready var upgrade_texture: TextureRect = $TextureRect
@onready var label: Label = $Label
@export var standard_texture: Texture2D
@export var hover_texture: Texture2D
@export var pressed_texture: Texture2D

var pressing: bool = false
var upgrade: UpgradeData
var sheet

func pressed():
	if sheet:
		sheet._upgrade_selected(upgrade)
func hover(value: bool):
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
			set_texture(pressed_texture)
		else:
			pressing = false
			if button.is_hovered():
				set_texture(hover_texture)
			else:
				set_texture(standard_texture)

func set_upgrade(upgrade_sheet, new_upgrade: UpgradeData):
	sheet = upgrade_sheet
	## Setup Buttons
	button.pressed.connect(pressed)
	button.button_down.connect(press.bind(true))
	button.button_up.connect(press.bind(false))
	button.mouse_entered.connect(hover.bind(true))
	button.mouse_exited.connect(hover.bind(false))
	## Setup Upgrade
	upgrade = new_upgrade
	self_modulate = upgrade.upgrade_color
	upgrade_texture.texture = upgrade.upgrade_image
	label.text = upgrade.upgrade_name
	# 10% of the upgrade color mixed into white
	label.self_modulate = Color.WHITE.lerp(upgrade.upgrade_color, 0.5)
