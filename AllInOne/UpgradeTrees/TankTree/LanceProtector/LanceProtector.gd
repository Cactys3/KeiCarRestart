extends SummonUpgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
func deactivate():
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
## Called by other upgrades to direct lance protector
func throw_spear_at_enemy(enemy: Enemy):
	if summons.size() > 0:
		summons[0].throw_spear_at_enemy(enemy)
