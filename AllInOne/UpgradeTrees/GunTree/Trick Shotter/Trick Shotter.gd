extends Upgrade
## This upgrade:
#
const piercing_damage_buff: float = 0.1
func activate(new_player: Character):
	Statics.projectile_pierce_damage_buff += piercing_damage_buff
	Statics.projectile_pierce_damage_buff_doubled_on_kill = true
	super(new_player)
func deactivate():
	Statics.projectile_pierce_damage_buff -= piercing_damage_buff
	Statics.projectile_pierce_damage_buff_doubled_on_kill = true
	super()
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
