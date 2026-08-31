extends Upgrade
## This upgrade:
#
const projectile_damage_debuff_reduction: float = 0.2
const count_buff = 1
func activate(new_player: Character):
	Statics.weapon_count_buff += count_buff
	Statics.additional_projectiles_damage_debuff -= projectile_damage_debuff_reduction
	super(new_player)
func deactivate():
	Statics.weapon_count_buff -= count_buff
	Statics.additional_projectiles_damage_debuff += projectile_damage_debuff_reduction
	super()
