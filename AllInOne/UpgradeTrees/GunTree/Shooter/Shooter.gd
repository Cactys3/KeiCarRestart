extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	Statics.weapon_attackspeed_buff += 2
	super(new_player)
func deactivate():
	Statics.weapon_attackspeed_buff -= 2
	super()
