extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	lance_protector_upgrade = find_upgrade("Lance Protector")
func deactivate():
	super()
func edit_attack_enemy(attack: Attack, enemy: Enemy) -> Attack:
	return super(attack, enemy)
func edit_attack(attack: Attack) -> Attack:
	return super(attack)
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

const behind_damage_modifier: float = -0.25
var lance_protector_upgrade: Upgrade

func edit_incoming_attack(attack: Attack, enemy: Enemy, character: Character) -> Attack:
	if enemy && character:
		var character_velocity: Vector2 = character.last_known_velocity.normalized()
		var enemy_facing: Vector2 = (character.global_position - enemy.global_position).normalized()
		var enemy_is_behind: bool = character_velocity.dot(enemy_facing) <= 0
		if enemy_is_behind:
			attack.temporary_factor_stats.add_to_stat(GlobalStats.DAMAGE, behind_damage_modifier)
			if lance_protector_upgrade:
				lance_protector_upgrade.throw_spear_at_enemy(enemy)
		if character_velocity.length_squared() < 0.0:
			printerr("Last known velocity is 0 when it shouldn't be right?")
	return super(attack, enemy, character)
