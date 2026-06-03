extends Upgrade
## This upgrade:
#
const projectile_damage_debuff: float = 0.4
const count_buff = 1
func activate(new_player: Character):
	Statics.weapon_count_buff += count_buff
	Statics.additional_projectiles_damage_debuff += projectile_damage_debuff
	super(new_player)
func deactivate():
	Statics.weapon_count_buff -= count_buff
	Statics.additional_projectiles_damage_debuff -= projectile_damage_debuff
	super()
func edit_attack(attack: Attack) -> Attack:
	## Damage reduce projectiles that can spawn multiple from main weapons
	if attack.attack_type == Attack.AttackTypes.player_weapon_projectile:
		var should_edit: bool = false
		var attacker = attack.attacker
		if attacker is Projectile:
			attacker = attacker as Projectile
			if attacker.can_spawn_multiple:
				should_edit = true
		else:
			should_edit = true
		
		if should_edit:
			attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, -Statics.additional_projectiles_damage_debuff)
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
