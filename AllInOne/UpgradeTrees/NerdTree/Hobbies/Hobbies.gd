extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	for u in upgrades:
		var upgrade = find_upgrade(u)
		if upgrade:
			found_upgrades.append(upgrade)
			upgrade.cooldown_finished.connect(hobby_completed)
		else:
			printerr("Couldn't find an upgrade to add to Hobbies: ", u)
func deactivate():
	super()
	for upgrade in found_upgrades:
		if upgrade:
			upgrade.cooldown_finished.disconnect(hobby_completed)
		else:
			printerr("Couldn't find an upgrade to remove from Hobbies")
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

const upgrades: Array[String] = ["Procrastination", "Printin", "Anime"]
var found_upgrades: Array[Upgrade] = []

func hobby_completed():
	pass ## TODO: implement Hobbies
