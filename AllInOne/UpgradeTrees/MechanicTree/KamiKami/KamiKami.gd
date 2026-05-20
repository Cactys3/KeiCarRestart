extends CreationUpgrade
## This upgrade:
# Every 10 enemy kills, spawn lil robot guys who walk to enemies and explode
func activate(new_player: Character):
	spawn_on_enemy_kills = true
	enemy_kills_to_spawn = enemy_kills_to_spawn_base
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const enemy_kills_to_spawn_base = 10
