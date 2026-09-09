extends SummonUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()

## Called by other upgrades to direct lance protector
func throw_spear_at_enemy(enemy: Enemy):
	if summons.size() > 0:
		summons[0].throw_spear_at_enemy(enemy)
