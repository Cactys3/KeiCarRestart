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
	if !buff_applied:
		apply_buff()

func apply_buff():
	Statics.player_movespeed_buff += movespeed_buff
	Statics.player_stance_buff += stance_buff
	Statics.changed_stats()
	super()
func remove_buff():
	Statics.player_movespeed_buff -= movespeed_buff
	Statics.player_stance_buff -= stance_buff
	Statics.changed_stats()
	super()
const movespeed_buff: float = 5
const stance_buff: float = 5
const stance_stat_buff: float = 5
const buff_time_on_damage: float = 2
