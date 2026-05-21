extends Upgrade
## This upgrade:
# Your summons gain 15% dodge chance
# Gain 15% dodge chance
func activate(new_player: Character):
	Statics.creation_dodge_buff += creation_dodge_buff
	GlobalStats.add_to_stats_base(GlobalStats.GHOSTLY, ghostly_buff)
	super(new_player)
func deactivate():
	Statics.creation_dodge_buff -= creation_dodge_buff
	GlobalStats.add_to_stats_base(GlobalStats.GHOSTLY, -ghostly_buff)
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const creation_dodge_buff: float = 15
const ghostly_buff: float = 15
