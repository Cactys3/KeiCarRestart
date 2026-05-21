extends CreationUpgrade
## This upgrade:
# Every 5 creation deaths, spawn a healing turret that locks onto a nearby ally, increasing their regen
# Your creations gain 15% damage
func activate(new_player: Character):
	connect_creation_killed = true
	Statics.creation_damage_buff = creation_damage_buff
	super(new_player)
func deactivate():
	Statics.creation_damage_buff = -creation_damage_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const creation_damage_buff: int = 15
var creations_died_since_spawn: int = 0
func creation_killed(creation: Creation, attack: Attack):
	creations_died_since_spawn += 1
	if creations_died_since_spawn >= 5:
		spawn()
		creations_died_since_spawn = 0
