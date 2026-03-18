extends Equipment
## An upgrade can be: an active weapon that damages enemies, a global stat buff, a passive to weapons, etc
class_name Upgrade

@export var upgrade_name: String
@export var upgrade_description: String

## Override
func activate(new_player: Character):
	super(new_player)
## Override
func deactivate():
	super()
