extends Upgrade
## This upgrade:
# Gain 20 additional health points
func activate(new_player: Character):
	super(new_player)
	Statics.player_hp_buff += hp_buff
	Statics.player_regen_buff += regen_buff
	
func deactivate():
	Statics.player_hp_buff -= hp_buff
	Statics.player_regen_buff -= regen_buff
	
	super()

const hp_buff: float = 20
const regen_buff: float = 4
