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

func shock_proc(shock_damage: float, enemy: Enemy):
	if buff_chance >= randf():
		Statics.player_shield_buff += 1
		shield_gained += 1
	super(shock_damage, enemy)

var shield_gained: int = 0
const buff_chance: float = 0.05
