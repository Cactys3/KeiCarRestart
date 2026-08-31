extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	Statics.projectile_size_buff += 0.2
	super(new_player)
func deactivate():
	Statics.projectile_size_buff -= 0.2
	super()
