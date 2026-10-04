extends TextureRect
@onready var upgrade_mini_icon: TextureRect = $UpgradeMiniIcon
@onready var label2: Label = $Label2
@onready var label: Label = $Label
var sheet
var is_ready: bool = false

func _process(delta: float) -> void:
	if !is_ready:
		return
	## If the user presses on something other than ourself, we die
	if Input.is_action_just_pressed("M1") && !get_global_rect().has_point(get_global_mouse_position()):
		kill()
func set_upgrade(upgrade_sheet, upgrade: UpgradeData):
	sheet = upgrade_sheet
	label.text = upgrade.upgrade_name
	label2.text = upgrade.upgrade_description
	upgrade_mini_icon.texture = upgrade.upgrade_image
	is_ready = true
## Remove this UpgradeDetails and all references
func kill():
	sheet.detailed_upgrade_ui = null
	sheet.showing_upgrade = null
	queue_free()
