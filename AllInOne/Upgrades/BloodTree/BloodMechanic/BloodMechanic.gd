extends Upgrade
## This upgrade:
#

## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Set Vars
func _ready() -> void:
	edits_attack = true
	super()
## Upgrade Turrets apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.attack_type == Attack.AttackTypes.upgrade_creation:
		attack.status.applies_bleed = true
	return attack

## TODO: Buff Turret
