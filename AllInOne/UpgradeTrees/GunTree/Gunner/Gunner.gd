extends Upgrade
## This upgrade:
# Projectiles deal 15 additional damage
func activate(new_player: Character):
	Statics.projectile_damage_buff += 15
	super(new_player)
func deactivate():
	Statics.projectile_damage_buff -= 15
	super()
func edit_attack(attack: Attack) -> Attack:
	#if attack.is_from_projectile():
		#attack.temporary_base_stats.add_to_stat(GlobalStats.DAMAGE, 15)
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
