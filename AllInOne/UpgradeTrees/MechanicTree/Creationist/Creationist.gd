extends Upgrade
## This upgrade:
# Gain a stacking buff when your creations kill an enemy. 
# Stacks up to 15 times, stacks start to expire 3 seconds after you gain a stack.
# Gain 1% creation damage and size per stack
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

const max_buff_stacks: int = 20
const buff_expire_cooldown: int = 5
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
