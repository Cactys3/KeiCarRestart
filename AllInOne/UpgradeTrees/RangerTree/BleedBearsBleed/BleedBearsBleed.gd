extends TrapUpgrade
## This upgrade:
# Your bear trap applies heavy bleed and immobilizes enemies for 3 seconds
# Your traps do 10% more damage
func activate(new_player: Character):
	connect_reload = true
	Statics.trap_damage_buff += trap_damage_buff
	super(new_player)
func deactivate():
	Statics.trap_damage_buff -= trap_damage_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const trap_damage_buff: float = 10

func reload(weapon: Weapon) -> void:
	spawn()
