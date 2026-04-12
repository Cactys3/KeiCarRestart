extends TrapUpgrade
## This upgrade:
# Your bear trap gains 50% size and damage through magical means
# Your traps gain 20% size
func activate(new_player: Character):
	connect_reload = true
	UpgradeStatics.trap_size_buff += trap_size_buff
	super(new_player)
func deactivate():
	UpgradeStatics.trap_size_buff -= trap_size_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const trap_size_buff: float = 10

func reload(weapon: Weapon) -> void:
	spawn()
