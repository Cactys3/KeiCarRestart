extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## Should attacks be passed through this upgrade before being sent to enemy
@export var edits_attack: bool = false
## Data about the prereqs etc, maybe not needed
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

## On Reload Signal
func reload() -> void:
	pass
## On Enemy Killed Signal
func enemy_killed() -> void:
	pass
