extends CreationUpgrade
## This upgrade:
# When you kill a boss, spawn an allied creation copy of it that fights for you!
func activate(new_player: Character):
	connect_boss_killed = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

## On Boss Killed Signal
func boss_killed(boss: Boss, attack: Attack) -> void:
	## TODO: implement stealing the boss's art/stats into a friendly thing
	boss.scene_file_path
