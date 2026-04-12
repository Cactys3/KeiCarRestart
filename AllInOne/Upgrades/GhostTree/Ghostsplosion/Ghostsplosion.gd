extends ProjectileUpgrade
## This upgrade:
# Every 10 seconds, explode with ghostly energy. 
# You dodge the damage of this explosion.
# The explosions count as projectiles. 
func activate(new_player: Character):
	## Explosion Spawned as a normal projectile
	## Start at 5 seconds
	stopwatch = 5
	spawn_every_seconds = 10
	spawn_with_cd = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass
