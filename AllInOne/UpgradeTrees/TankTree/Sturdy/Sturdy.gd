extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_knockback_resistance_buff -= knockback_resist_buff
	Statics.player_stance_buff += stance_buff
	
func deactivate():
	super()
	Statics.player_knockback_resistance_buff += knockback_resist_buff
	Statics.player_stance_buff -= stance_buff
	
const knockback_resist_buff: float = 0.2
const stance_buff: float = 5
