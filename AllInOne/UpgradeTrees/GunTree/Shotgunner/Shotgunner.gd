extends Upgrade
## This upgrade:
#
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	print("What ")
	## Must be a projectile
	if attack.is_projectile():
		## Projectiles deal more damage based on how close the enemy and player are
		var distance: float = enemy.global_position.distance_to(game_man.instance.player.global_position)
		# max damage at 20m
		# no damage at 50m
		var percent: float = clamp((distance - 20.0) / (50.0 - 20.0), 0.0, 1.0)
		var damage_buff: float = lerp(max_damage_buff, 0.0, percent)
		if damage_buff > 0:
			if DebugManager.UpgradeEditedAttack:
				print("Shotgunner Edit: +", damage_buff, " to base damage: ", attack.temporary_base_stats.get_stat(GlobalStats.DAMAGE))
			attack.temporary_base_stats.add_to_stat(GlobalStats.DAMAGE, damage_buff)
	return super(attack, enemy)


const max_damage_buff: float = 30
