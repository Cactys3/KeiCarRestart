extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_shield_buff += shield_buff
	
func deactivate():
	super()
	Statics.player_shield_buff -= shield_buff
	

const shield_buff: float = 15
