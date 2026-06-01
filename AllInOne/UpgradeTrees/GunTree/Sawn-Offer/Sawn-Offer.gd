extends Upgrade
## This upgrade:
#
const count_buff: float = 3
const projectile_damage_anti_debuff: float = 0.2
const inaccuracy_increase: float = 20
func activate(new_player: Character):
	Statics.weapon_count_buff += count_buff
	Statics.spawn_count_buff += count_buff
	Statics.additional_projectiles_damage_debuff -= projectile_damage_anti_debuff
	Statics.weapon_inaccuracy_buff += inaccuracy_increase
	Statics.spawn_inaccuracy_buff += inaccuracy_increase
	super(new_player)
func deactivate():
	Statics.weapon_count_buff -= count_buff
	Statics.spawn_count_buff -= count_buff
	Statics.additional_projectiles_damage_debuff += projectile_damage_anti_debuff
	Statics.weapon_inaccuracy_buff -= inaccuracy_increase
	Statics.spawn_inaccuracy_buff -= inaccuracy_increase
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
