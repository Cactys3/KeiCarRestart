extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_movespeed_buff += movespeed_buff
func deactivate():
	super()
	Statics.player_movespeed_buff -= movespeed_buff
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	## Deal more damage based on how fast player is moving
	## Must be a projectile
	if attack.is_projectile():
		var damage_buff = 0
		## Buff = movespeed past 30 (default)
		if !player.stunning:
			damage_buff = player.velocity.length() - Character.default_movespeed
			print(" Velocity: ", player.velocity.length(), " buff ", damage_buff)
		if damage_buff > 0:
			if DebugManager.UpgradeEditedAttack:
				print("Elite Sniper Edit: +", damage_buff, " to base damage: ", attack.temporary_base_stats.get_stat(GlobalStats.DAMAGE))
			attack.temporary_base_stats.add_to_stat(GlobalStats.DAMAGE, damage_buff)
	return super(attack, enemy)

const movespeed_buff: float = 5
