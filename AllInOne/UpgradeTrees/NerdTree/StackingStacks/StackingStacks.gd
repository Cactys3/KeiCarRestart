extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
	while curr_stacks > 0:
		curr_stacks -= 1
		Statics.spawn_size_buff -= size_buff_per_stack
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

const size_buff_per_stack: float = 0.02
const max_stacks: int = 100
var curr_stacks: int = 0
var decay_stopwatch: float = 0
const decay_rate: float = 2
func _process(delta: float) -> void:
	super(delta)
	if active && curr_stacks > 0:
		decay_stopwatch += delta
		if decay_stopwatch >= decay_rate:
			decay_stopwatch = 0
			reduce()
func upgrade_cooldown_finished(upgrade: Upgrade):
	if curr_stacks < max_stacks:
		curr_stacks += 1
		Statics.spawn_size_buff += size_buff_per_stack
func reduce():
	if curr_stacks > 0:
		curr_stacks -= 1
		Statics.spawn_size_buff -= size_buff_per_stack
