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
const ghostly_buff: int = 10
const movespeed_buff: int = 20
const movespeed_buff_duration: float = 10
## Called on dodging
func dodge(character: Character, attack: Attack):
	buff_time_left = movespeed_buff_duration
	buff_applied = true
	GlobalStats.add_to_stats_base(GlobalStats.MOVESPEED, movespeed_buff)
func remove_buff():
	GlobalStats.add_to_stats_base(GlobalStats.MOVESPEED, -movespeed_buff)
