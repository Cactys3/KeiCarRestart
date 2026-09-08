extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.upgrade_cooldown_rate += buff
func deactivate():
	super()
	Statics.upgrade_cooldown_rate -= buff

const buff: float = 3
