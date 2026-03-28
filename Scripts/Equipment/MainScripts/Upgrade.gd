extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## variables set in ready() method or by UpgradeData

## Should attacks be passed through this upgrade before being sent to enemy
var edits_attack: bool = false
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
func _process(delta: float) -> void:
	super(delta)
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Override method to edit an attack and return
func edit_attack(attack: Attack) -> Attack:
	return attack
## Overide method to edit the list of stats
func edit_stats():
	pass
