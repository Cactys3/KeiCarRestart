extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade
## Data about the prereqs etc, maybe not needed
var data: UpgradeData
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
