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
## Apply double bleed on critical hits
func edit_attack(attack: Attack) -> Attack:
	if attack.get_crit():
		attack.status.applies_bleed = true
		attack.temporary_factor_stats.add_to_stat(GlobalStats.BLEED_APPLY, 1)
	return attack
