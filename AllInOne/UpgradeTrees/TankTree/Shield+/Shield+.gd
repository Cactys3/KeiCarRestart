extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	calculate_and_apply(GameManager.instance.max_hp)
func deactivate():
	super()
	Statics.player_shield_buff -= curr_buff_applied
	curr_buff_applied = 0


const hp_percent_buff: float = 0.15
var curr_buff_applied: float = 0

func recaclulate():
	calculate_and_apply(GameManager.instance.max_hp)
	

func calculate_and_apply(max_hp: float):
	## Remove old
	Statics.player_shield_buff -= curr_buff_applied
	## Add new
	curr_buff_applied = hp_percent_buff * max_hp
	Statics.player_shield_buff += curr_buff_applied
	Statics.changed_stats()

func player_maxhp_changed(new_maxhp: float, old_maxhp: float):
	print("Did it change? ", new_maxhp, " old ", old_maxhp)
	if new_maxhp > old_maxhp:
		calculate_and_apply(new_maxhp)
	super(new_maxhp, old_maxhp)
