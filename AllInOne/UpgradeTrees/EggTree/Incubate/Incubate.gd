extends Upgrade
## This upgrade:
#
var egg_upgrade: EggUpgrade
const egg_name: String = "Egg"
const time_addition: float = 60 * 2 

func activate(new_player: Character):
	super(new_player)
	egg_upgrade = find_upgrade(egg_name)
	if egg_upgrade:
		egg_upgrade.time_until_hatch += time_addition
		egg_upgrade.total_time_duration += time_addition

func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)
func apply_buff():
	super()
func remove_buff():
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)
