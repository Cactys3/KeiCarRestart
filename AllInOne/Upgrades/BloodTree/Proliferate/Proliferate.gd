extends Upgrade
## This upgrade:
#
const blood_damage_buff_factor = 0.25
const blood_apply_buff_factor = 0.5
## set Edits attack
func _ready() -> void:
	edits_attack = true
	super()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	super()
## Apply more bleed, damage more bleed
func edit_stats():
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_APPLY, blood_apply_buff_factor)
	GlobalStats.add_to_stats_factor(GlobalStats.BLEED_DAMAGE, blood_damage_buff_factor)
