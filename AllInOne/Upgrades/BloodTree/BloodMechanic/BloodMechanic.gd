extends Upgrade
## This upgrade:
#

## Enables the functionality of this upgrade
func activate(new_player: Character):
	var found: bool = false
	for upgrade in GameManager.instance.active_upgrades:
		if upgrade.data.upgrade_name == "BloodTurrets":
			upgrade.disabled_by_inherited_upgrade = true
			found = true
	if !found:
		printerr("Couldn't Find BloodNeedles to disable them (from BloodyMagazine)")
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Set Vars
func _ready() -> void:
	edits_attack = true
## Upgrade Turrets apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.attack_type == Attack.AttackTypes.upgrade_turret:
		attack.status.applies_bleed = true
	return attack

## TODO: Buff Turret
