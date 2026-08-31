extends Upgrade
## This upgrade:
#
const count_buff: float = 3
const projectile_damage_anti_debuff: float = 0.2
const inaccuracy_increase: float = 20
func activate(new_player: Character):
	Statics.weapon_count_buff += count_buff
	Statics.additional_projectiles_damage_debuff -= projectile_damage_anti_debuff
	Statics.weapon_inaccuracy_buff += inaccuracy_increase
	super(new_player)
func deactivate():
	Statics.weapon_count_buff -= count_buff
	Statics.additional_projectiles_damage_debuff += projectile_damage_anti_debuff
	Statics.weapon_inaccuracy_buff -= inaccuracy_increase
	super()
