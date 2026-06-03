extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	## Must be a projectile
	if attack.is_from_projectile():
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

const max_damage_buff: float = 30
