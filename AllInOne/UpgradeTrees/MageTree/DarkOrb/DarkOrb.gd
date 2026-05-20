extends SummonUpgrade
## This upgrade:
# Summon a dark orb that orbits the player, dealing damage and slowing.
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass
