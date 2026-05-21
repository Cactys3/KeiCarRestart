extends CreationUpgrade
## This upgrade:
# Every 15 seconds, spawn a decoy robot that enemies will attack instead of you
# (enemies will move towards robot if they get in range of the robot)
# Your creations gain 15% hp
func activate(new_player: Character):
	spawn_with_cd = true
	spawn_every_seconds = spawning_cd
	Statics.creation_hp_buff += creation_hp_buff
	super(new_player)
func deactivate():
	Statics.creation_hp_buff -= creation_hp_buff
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const creation_hp_buff: float = 15
const spawning_cd: int = 15
