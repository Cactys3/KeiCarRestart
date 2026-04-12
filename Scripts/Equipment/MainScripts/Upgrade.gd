extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## variables set in ready() method or by UpgradeData

## Booleans that say what this upgrade does
## Should attacks be passed through this upgrade before being sent to enemy
@export var edits_attack: bool = false
@export var buffs_weapon_stats: bool = false
@export var buffs_player_stats: bool = false
## Variables given by UpgradeData
var spawns_projectile: bool = false
var spawns_summon: bool = false
var spawns_creation: bool = false
var spawns_trap: bool = false
var upgrades_to_overwrite_functionality: Array[UpgradeData]
var upgrade_rarity: Upgrade.UpgradeRarities = UpgradeRarities.unset
enum UpgradeRarities {unset, Basic, Intermediate, Advanced, Exclusive}
const BASIC_COLOR: Color = Color.RED
const INTERMEDIATE_COLOR: Color = Color.BLUE
const ADVANCED_COLOR: Color = Color.REBECCA_PURPLE
const EXCLUSIVE_COLOR: Color = Color.LIGHT_GOLDENROD
var data: UpgradeData
## Disable all functions 
var disabled_by_inherited_upgrade: bool = false
## statics
static var upgrade_buffs_duration_factor: float = 1
## Check to remove buffs or other stuff on leaving scene
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		check_remove()
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	if buff_applied && buff_time_left > 0:
		buff_time_left -= delta
	else:
		check_remove()
## Override below
## Enables the functionality of this upgrade
func activate(new_player: Character):
	var upgrades_found: Array[UpgradeData] = upgrades_to_overwrite_functionality
	for upgrade in GameManager.instance.active_upgrades:
		if upgrades_to_overwrite_functionality.has(upgrade.data):
			upgrade.disabled_by_inherited_upgrade = true
			upgrades_found.erase(upgrade.data)
	if !upgrades_found.is_empty():
		var error = ""
		for upgrade in upgrades_found:
			error += str("Couldn't Find ", upgrade.data.upgrade_name, " to disable them (from ", data.upgrade_name, ")\n")
		printerr(error)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	check_remove()
	super()
## Override method to edit an attack and return
func edit_attack(attack: Attack) -> Attack:
	return attack
## Overide method to edit the list of stats
func edit_stats():
	pass
var buff_time_left: float = 0
var buff_applied: bool = false
## Checks if a buff is applied and calls remove_buff()
func check_remove():
	if buff_applied:
		remove_buff()
func remove_buff():
	buff_applied = false
	pass
