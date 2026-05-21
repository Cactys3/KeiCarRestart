extends Upgrade
## This upgrade:
# Your summons' dodge procs count as your own.
# Your summons gain 15% dodge chanc
func activate(new_player: Character):
	Statics.creation_dodge_buff += creation_dodge_buff
	Statics.creation_dodges_count_for_player += 1
	super(new_player)
func deactivate():
	Statics.creation_dodges_count_for_player -= 1
	Statics.creation_dodge_buff -= creation_dodge_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass
const creation_dodge_buff: float = 15
