extends CreationUpgrade
## This upgrade:
# Spawn our Creation with Printin's spawn
var sought_upgrade: String = "Printin"
func activate(new_player: Character):
	var upgrade: Upgrade = find_upgrade(sought_upgrade)
	if upgrade:
		upgrade.cooldown_finished.connect(spawn)
	else:
		printerr("Couldn't find upgrade: ", sought_upgrade)
	super(new_player)
func deactivate():
	var upgrade: Upgrade = find_upgrade(sought_upgrade)
	if upgrade:
		upgrade.cooldown_finished.disconnect(spawn)
	else:
		printerr("Couldn't find upgrade: ", sought_upgrade)
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
