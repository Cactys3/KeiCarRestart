extends CreationUpgrade
## This upgrade:
# Your flame turret instead shoots copies of your main weapon's projectiles
# Your main weapon's projectiles apply burn.
func activate(new_player: Character):
	connect_reload = true
	edits_attack = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	print("Edit attack! Cutting!")
	if attack.is_from_weapon():
		attack.status.applies_bleed = true
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

func reload(weapon: Weapon) -> void:
	spawn()
