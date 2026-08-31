extends Upgrade
## This upgrade:
#
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	## TODO: Deal bonus damage based on how far enemy is from player
	## Must be a projectile
	if attack.is_projectile():
		## Projectiles deal more damage based on how close the enemy and player are
		var distance: float = enemy.global_position.distance_to(game_man.instance.player.global_position)
		## max damage at 200m
		## no damage at 100m 
		#print("Dist: ", distance)
		#var percent: float = clamp((200.0 - distance) / 100.0, 0.0, 1.0)
		#var damage_buff: float = lerp(max_damage_buff, 0.0, percent)
		
		## Buff starts at 130m
		## buff damage percent = distance past 130 * 0.5
		var damage_buff = 0
		if distance > 100:
			damage_buff = (distance - 130) / 200
		if damage_buff > 0:
			if DebugManager.UpgradeEditedAttack:
				print("Elite Sniper Edit: +", damage_buff, " to base damage: ", attack.temporary_base_stats.get_stat(GlobalStats.DAMAGE))
			attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, damage_buff)
	return super(attack, enemy)

const max_damage_buff: float = 2
