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
	## TODO: projectiles deal more damage based on how close the enemy and player are
	
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
