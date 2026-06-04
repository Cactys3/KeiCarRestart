extends SummonUpgrade
## This upgrade:
## Spawn the egg to orbit the player
## Set the timer to appear above the orbiting egg
## Once the timer is done, replace the egg with the summon

# 4 minutes
var time_until_hatch: float = 4 * 60
var hatched: bool = false
var egg: Summon
var hatchling: Summon

func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_stats():
	super()
func disable_upgrade(upgrade: Upgrade):
	super(upgrade)
func apply_buff():
	super()
func remove_buff():
	super()
func _process(delta: float) -> void:
	super(delta)
	if active && !hatched:
		time_until_hatch -= delta
		if time_until_hatch < 0:
			hatch()
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

func hatch():
	hatched = true
