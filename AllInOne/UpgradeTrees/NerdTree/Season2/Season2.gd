extends CreationUpgrade
## This upgrade:
# Spawn our Creation with Anime's spawn
var sought_upgrade: String = "Anime"
var failed_to_find: bool = false
func activate(new_player: Character):
	var upgrade: Upgrade = find_upgrade(sought_upgrade)
	if upgrade:
		upgrade.cooldown_finished.connect(spawn)
	else:
		printerr("Couldn't find upgrade: ", sought_upgrade)
		failed_to_find = true
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
var find_upgrade_stopwatch: float = 0
func _process(delta: float) -> void:
	super(delta)
	if active && failed_to_find:
		if find_upgrade_stopwatch > 3:
			find_upgrade_stopwatch = 0
			var upgrade: Upgrade = find_upgrade(sought_upgrade)
			if upgrade:
				upgrade.cooldown_finished.connect(spawn)
				failed_to_find = false
			else:
				printerr("Couldn't find upgrade: ", sought_upgrade)
				failed_to_find = true
		else:
			find_upgrade_stopwatch += delta
