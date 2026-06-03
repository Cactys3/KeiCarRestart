extends Upgrade
## This upgrade:
# Move 20% faster for 10 seconds after dodging damage
# Gain 10 ghostly (dodge chance)
func activate(new_player: Character):
	GlobalStats.add_to_stats_base(GlobalStats.GHOSTLY, ghostly_buff)
	super(new_player)
func deactivate():
	GlobalStats.add_to_stats_base(GlobalStats.GHOSTLY, -ghostly_buff)
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
## Called on dodging
func dodge(character: Character, attack: Attack):
	add_to_buff_time(movespeed_buff_duration)
	buff_applied = true
	Statics.player_movespeed_factor += movespeed_buff
func remove_buff():
	Statics.player_movespeed_factor -= movespeed_buff

const ghostly_buff: float = 15
const movespeed_buff: float = 0.2
const movespeed_buff_duration: float = 10
