extends Upgrade
## This upgrade:
# Gain a duplicate copy of your main weapon
func activate(new_player: Character):
	add_weapon()
	super(new_player)
func deactivate():
	remove_weapon()
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

var duplicate_weapon: Weapon = null

func add_weapon():
	if game_man.weapon_list.size() > 0:
		duplicate_weapon = game_man.weapon_list[0].duplicate()
		game_man.add_weapon(duplicate_weapon)
func remove_weapon():
	if duplicate_weapon:
		game_man.remove_weapon(duplicate_weapon)
