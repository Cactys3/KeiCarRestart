extends SummonUpgrade
## This upgrade:
# Spawn the summon, tell it to attack? probably it figures out attacking on its own
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func remove_buff():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)

func upgrade_cooldown_finished(upgrade: Upgrade):
	pass ## Tell summon to attack?
