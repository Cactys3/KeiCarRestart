extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## Should attacks be passed through this upgrade before being sent to enemy
@export var edits_attack: bool = false
@export var upgrade_rarity: Upgrade.UpgradeRarities = UpgradeRarities.unset
enum UpgradeRarities {unset, Basic, Intermediate, Advanced, Exclusive}
const BASIC_COLOR: Color = Color.RED
const INTERMEDIATE_COLOR: Color = Color.BLUE
const ADVANCED_COLOR: Color = Color.REBECCA_PURPLE
const EXCLUSIVE_COLOR: Color = Color.LIGHT_GOLDENROD
var data: UpgradeData
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
## On Reload Signal
func reload() -> void:
	pass
## On Enemy Killed Signal
func enemy_killed() -> void:
	pass
