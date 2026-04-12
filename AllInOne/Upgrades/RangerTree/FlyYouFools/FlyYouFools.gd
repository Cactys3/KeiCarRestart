extends Upgrade
## This upgrade:
# Gain 20% movespeed for 3 seconds on reload
func activate(new_player: Character):
	connect_reload = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	GlobalStats.add_to_stats_factor(GlobalStats.MOVESPEED, -movespeed_buff)
const movespeed_buff: float = 20
func reload(weapon: Weapon) -> void:
	GlobalStats.add_to_stats_factor(GlobalStats.MOVESPEED, movespeed_buff)
