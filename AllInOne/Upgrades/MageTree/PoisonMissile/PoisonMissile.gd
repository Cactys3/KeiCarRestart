extends ProjectileUpgrade
## This upgrade:
# Your magic missiles becomes poison missiles
# Poison missiles fire every 8 seconds and apply poison
func activate(new_player: Character):
	spawn_with_cd = true
	spawn_every_seconds = projectile_cooldown
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const projectile_cooldown: int = 8
