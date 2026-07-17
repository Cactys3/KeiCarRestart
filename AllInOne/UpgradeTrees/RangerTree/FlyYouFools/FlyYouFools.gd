extends Upgrade
## This upgrade:
# Gain 20% movespeed for 3 seconds on reload
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	Statics.player_movespeed_buff -= movespeed_buff
	super()
const movespeed_buff: float = 25
const buff_duration: float = 1
func reload(weapon: Weapon) -> void:
	buff_time_left += buff_duration
	if !buff_applied:
		apply_buff()
func apply_buff():
	Statics.player_movespeed_buff += movespeed_buff
	super()
