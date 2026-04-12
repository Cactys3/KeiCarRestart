extends ProjectileUpgrade
## This upgrade:
# Shoot a black arrow at the strongest nearby enemy on reload
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
