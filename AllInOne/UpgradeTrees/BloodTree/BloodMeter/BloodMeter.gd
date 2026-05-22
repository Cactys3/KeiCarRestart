extends MeterUpgrade
## This upgrade:
# Adds a blood meter, dmg increase based on meter, size at max meter
const meter_gain_per_blood_proc: float = 5
const max_damage_buff: float = 0.20 # 20%
const size_buff: float = 0.1 # 10%
func _process(delta: float) -> void:
	super(delta)
## Enables the functionality of this upgrade
func activate(new_player: Character):
	meter_color = Color.RED
	meter_loss_per_second = 0
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
func bleed_proc(bleed_damage: float, enemy: Enemy):
	super(bleed_damage, enemy)
	add_to_meter(meter_gain_per_blood_proc + 30)
func edit_attack(attack: Attack) -> Attack:
	## Apply a percent of the max_damage_buff based on current meter
	attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, (curr_value / max_value) * max_damage_buff)
	return super(attack)
func remove_buff():
	GlobalStats.add_to_stats_factor(GlobalStats.SIZE, size_buff)
	super()
func apply_buff():
	GlobalStats.add_to_stats_factor(GlobalStats.SIZE, -size_buff)
	super()
func max_meter():
	if !buff_applied:
		apply_buff()
