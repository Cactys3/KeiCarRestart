extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()

func shock_proc(shock_damage: float, enemy: Enemy):
	if buff_chance >= randf():
		Statics.player_shield_buff += 1
		shield_gained += 1
	super(shock_damage, enemy)

var shield_gained: int = 0
const buff_chance: float = 0.05
