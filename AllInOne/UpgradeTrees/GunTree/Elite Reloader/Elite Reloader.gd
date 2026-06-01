extends Upgrade
## This upgrade:
#
const damage_buff: float = 0.05 # 5%
const buff_duration: float = 3
func activate(new_player: Character):
	super(new_player)
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
	## TODO: damage buff
	GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, damage_buff)
	add_to_buff_time(buff_duration)
	super()
func remove_buff():
	GlobalStats.add_to_stats_factor(GlobalStats.DAMAGE, -damage_buff)
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

func reload(weapon: Weapon) -> void:
	apply_buff()
	super(weapon)
