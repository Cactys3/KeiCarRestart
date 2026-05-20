extends CreationUpgrade
## This upgrade:
# Create an ally ghost Creation whenever you take damage.
func activate(new_player: Character):
	connect_player_damaged = true
	spawn_on_reload = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

func player_damaged(character: Character, attack: Attack):
	spawn()
