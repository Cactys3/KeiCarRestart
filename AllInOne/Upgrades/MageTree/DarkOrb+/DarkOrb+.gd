extends SummonUpgrade
## This upgrade:
# Your dark orb gains its own gravity, pulling enemies towards it and dealing DOT damage as they get close.
# Your dark orb gains 1% size when it lands the killing blow on an enemy.
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
