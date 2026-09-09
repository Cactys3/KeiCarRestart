extends Upgrade
## This upgrade:
# Gain 20 additional health points
func activate(new_player: Character):
	super(new_player)
	Statics.player_hp_buff += hp_buff
	Statics.changed_stats()
func deactivate():
	Statics.player_hp_buff -= hp_buff
	Statics.changed_stats()
	super()

const hp_buff: float = 20
