extends Upgrade
## This upgrade:
# On max buff stacks, your creations gain 40% attackspeed and 50% size
# Stacks up to 20 times, stacks start to expire 5 seconds after you gain a stack.
func activate(new_player: Character):
	connect_enemy_killed = true
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
const max_stacks_attackspeed_buff: int = 40
const max_stacks_size_buff: int = 50
var at_max_stacks: bool = false
const max_buff_stacks: int = 15
const buff_expire_cooldown: int = 2
const creation_per_stack_buff: int = 1
var buff_stacks: int = 0
var buff_stopwatch: float = 0
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	if attack.attack_type == Attack.AttackTypes.upgrade_creation:
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
	Statics.creation_damage_buff += (creation_per_stack_buff) * value
	Statics.creation_size_buff += (creation_per_stack_buff) * value
	## Check max stacks
	if buff_stacks == max_buff_stacks && !at_max_stacks:
		at_max_stacks = true
		Statics.creation_attackspeed_buff += max_stacks_attackspeed_buff
		Statics.creation_size_buff += max_stacks_size_buff
	if buff_stacks != max_buff_stacks && at_max_stacks:
		at_max_stacks = false
		Statics.creation_attackspeed_buff -= max_stacks_attackspeed_buff
		Statics.creation_size_buff -= max_stacks_size_buff
