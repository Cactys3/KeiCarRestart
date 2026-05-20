extends SummonUpgrade
## This upgrade:
# Spawn a gnome creation that fires magical beams equal to the number of projectiles onscreen every 10 seconds. 
# (magical beams don't count towards number of projectiles, in case multiple gnomes)
func activate(new_player: Character):
	spawn_with_cd = true
	spawn_every_seconds = spawning_cooldown
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const spawning_cooldown: int = 10
