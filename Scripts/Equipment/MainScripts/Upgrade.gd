extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade

@export var upgrade_name: String
@export var upgrade_description: String

## enable and apply the functionality of this upgrade
func activate():
	pass
## disable and halt the functionality of this upgrade
func deactivate():
	pass
