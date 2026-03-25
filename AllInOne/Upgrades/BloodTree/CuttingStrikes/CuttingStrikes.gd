extends Upgrade

## This upgrade:
#

## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Override method to edit an attack and return
func edit_attack(attack: Attack) -> Attack:
	print("Edit attack! Cutting!")
	if attack.is_from_weapon():
		attack.status.applies_bleed = true
	return attack
