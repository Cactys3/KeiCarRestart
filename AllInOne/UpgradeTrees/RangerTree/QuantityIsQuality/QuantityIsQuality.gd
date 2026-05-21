extends TrapUpgrade
## This upgrade:
# Spawn 2 more bear traps on reload
# Your reload spawns trigger an additional time
# Your traps last for 40% longer
func activate(new_player: Character):
	additional_spawns += 2
	connect_reload = true
	Statics.reload_spawns_count_buff += reload_spawns_count_buff
	Statics.trap_duration_buff += trap_duration_buff
	super(new_player)
func deactivate():
	additional_spawns -= 2
	Statics.reload_spawns_count_buff -= reload_spawns_count_buff
	Statics.trap_duration_buff -= trap_duration_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const trap_duration_buff: float = 10
const reload_spawns_count_buff: int = 1

func reload(weapon: Weapon) -> void:
	spawn()
