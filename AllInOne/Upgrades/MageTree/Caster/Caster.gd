extends Upgrade
## This upgrade:
# Gain a stacking buff for 5 seconds when you spawn a projectile, stacks 8 times up.
# Each stack grants 2% damage and 2% size.
func activate(new_player: Character):
	connect_projectile_spawned = true
	super(new_player)
func deactivate():
	if buff_stacks > 0:
		apply_buff(-buff_stacks)
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass

const max_buff_stacks: int = 20
const buff_expire_cooldown: int = 5
const damage_per_stack_buff: int = 1
const size_per_stack_buff: int = 1
var buff_stacks: int = 0
var buff_stopwatch: float = 0
func projectile_spawned(projectile: Projectile):
	## Add a stack and reset stacks resetting cooldown
	if buff_stacks < max_buff_stacks:
		apply_buff(1)
func _process(delta: float) -> void:
	if buff_stacks > 0:
		buff_stopwatch -= delta
		if buff_stopwatch <= 0:
			apply_buff(-1)
	super(delta)
## Value is Either -1 or 1
func apply_buff(value: int):
	buff_stopwatch = buff_expire_cooldown
	buff_stacks += value
	UpgradeStatics.global_damage_buff += (damage_per_stack_buff) * value
	UpgradeStatics.global_projectile_size_buff += (size_per_stack_buff) * value
