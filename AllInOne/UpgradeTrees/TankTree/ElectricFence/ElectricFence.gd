extends ProjectileUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_shield_buff += shield_buff
func deactivate():
	super()
	Statics.player_shield_buff -= shield_buff
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

const shield_buff: float = 10
var target: Enemy
## On 
func player_shield_damaged(character: Character, attack: Attack, shield_damage_amount: float):
	var enemy = attack.attacker
	if attack.is_from_enemy() && enemy:
		target = enemy
		spawn()
	super(character, attack, shield_damage_amount)
## Return the predetermined target that attacked our shield last
func get_spawn_target() -> Node2D:
	return target
