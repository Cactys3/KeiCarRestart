extends Upgrade
## This upgrade:
#
const count_factor_buff: float = 1
func activate(new_player: Character):
	## spawn_count_factor here is the spawns when they create a projectile right?
	Statics.weapon_count_factor += count_factor_buff
	Statics.spawn_count_factor += count_factor_buff
	super(new_player)
func deactivate():
	Statics.weapon_count_factor -= count_factor_buff
	Statics.spawn_count_factor -= count_factor_buff
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
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)
