extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_stance_buff += stance_stat_buff
func deactivate():
	super()
	Statics.player_stance_buff -= stance_stat_buff

func player_damaged(character: Character, attack: Attack):
	add_to_buff_time(buff_time_on_damage)
	apply_buff()

const movespeed_buff: float = 0.2
const stance_stat_buff: float = 5
const buff_time_on_damage: float = 2
