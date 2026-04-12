extends SummonUpgrade
## This upgrade:
# Summon an allied ghost Summon that swims around you, damaging enemies. 
# It has a 10% chance to fear enemies it comes in contact with.
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
