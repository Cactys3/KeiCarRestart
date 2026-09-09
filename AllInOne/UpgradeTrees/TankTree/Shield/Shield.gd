extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_shield_buff += shield_buff
	Statics.changed_stats()
func deactivate():
	super()
	Statics.player_shield_buff -= shield_buff
	Statics.changed_stats()

const shield_buff: float = 15
