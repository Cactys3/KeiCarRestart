extends TrapUpgrade

## This upgrade:
# on reload, Spawn a bear trap that applies bleed and slows for 3 seconds

func activate(new_player: Character):
	connect_reload = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

func reload(weapon: Weapon) -> void:
	spawn()
