extends TextureRect
class_name UpgradeSheet

@onready var grid: GridContainer = $GridContainer

var showing: bool = true
var showing_upgrade: UpgradeData = null
var detailed_upgrade_ui: Control
var upgrades: Array[Control]
const OBTAINED_UPGRADE = preload("uid://dvuvwvg4ujfol")
const UPGRADE_DETAILS = preload("uid://c5as4nmbvb33g")

## Add an Upgrade to the Upgrade Sheet
func add_upgrade(upgrade: UpgradeData):
	var new_upgrade = OBTAINED_UPGRADE.instantiate()
	grid.add_child(new_upgrade)
	new_upgrade.set_upgrade(self, upgrade)
	upgrades.append(new_upgrade)

## Button Press Functions

## Hide and Show upgrade sheet
func _pull_tab_pressed():
	if showing:
		position += Vector2(-size.x, 0)
	else:
		position += Vector2(size.x, 0)
	showing = !showing

## Show Detailed Info About Selected Upgrade
func _upgrade_selected(upgrade: UpgradeData):
	if detailed_upgrade_ui != null:
		detailed_upgrade_ui.queue_free()
		detailed_upgrade_ui = null
	showing_upgrade = upgrade
	detailed_upgrade_ui = UPGRADE_DETAILS.instantiate()
	add_child(detailed_upgrade_ui)
	## Offset so the player can spam click and the created UI doesn't block mouse to button (for fun)
	detailed_upgrade_ui.global_position = get_global_mouse_position() + Vector2(-3,  3)
	detailed_upgrade_ui.set_upgrade(self, upgrade)
