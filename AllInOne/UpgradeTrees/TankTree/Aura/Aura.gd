extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
var buff_gained: float = 0
const hp_buff: float = 1
const chance: float = 0.25
func player_damaged(character: Character, attack: Attack):
	if chance >= randf():
		Statics.player_hp_buff += hp_buff
		buff_gained += hp_buff
	super(character, attack)
