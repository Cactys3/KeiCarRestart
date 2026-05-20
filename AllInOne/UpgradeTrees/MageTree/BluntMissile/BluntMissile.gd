extends ProjectileUpgrade
## This upgrade:
# Your magic missiles becomes fist missiles 
# Fist missiles fire every 5 seconds and deal strong damage with massive knockback
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

const projectile_cooldown: int = 5 
