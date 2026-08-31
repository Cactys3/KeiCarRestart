extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	Statics.projectile_piercing_buff += 1
	Statics.projectile_velocity_factor += 0.15
	super(new_player)
func deactivate():
	Statics.projectile_piercing_buff -= 1
	Statics.projectile_velocity_factor -= 0.15
	super()
