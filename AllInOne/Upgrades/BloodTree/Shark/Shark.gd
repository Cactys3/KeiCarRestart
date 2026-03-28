extends Upgrade
## This upgrade:
#

## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
const damage_buff_to_bled: float = 0.2
## Set Vars
func _ready() -> void:
	edits_attack = true
	connect_bleed_proc
## Upgrade Turrets apply bleed
func edit_attack(attack: Attack) -> Attack:
	if attack.status.applies_bleed:
		attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, damage_buff_to_bled)
	return attack

func bleed_proc(bleed_damage: float, enemy: Enemy):
	## TODO: heal player
	super(bleed_damage, enemy)
