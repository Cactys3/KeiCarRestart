extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.weapon_reloadtime_factor -= 0.2
func deactivate():
	Statics.weapon_reloadtime_factor += 0.2
	super()
