extends Upgrade
## This upgrade:
#
func _ready() -> void:
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	buff_applied = true
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, blood_apply_buff_factor)
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_DAMAGE, blood_damage_buff_factor)
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, -blood_apply_buff_factor)
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_DAMAGE, -blood_damage_buff_factor)
	super()
const blood_damage_buff_factor = 0.25
const blood_apply_buff_factor = 0.5
