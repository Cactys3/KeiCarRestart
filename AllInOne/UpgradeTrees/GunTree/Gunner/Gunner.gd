extends Upgrade
## This upgrade:
# Projectiles deal 15 additional damage
func activate(new_player: Character):
	Statics.projectile_damage_buff += 15
	super(new_player)
func deactivate():
	Statics.projectile_damage_buff -= 15
	super()
