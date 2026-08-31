extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	Statics.weapon_range_factor += 0.3
	Statics.projectile_velocity_factor += 0.3
	super(new_player)
func deactivate():
	Statics.weapon_range_factor -= 0.3
	Statics.projectile_velocity_factor -= 0.3
	super()
