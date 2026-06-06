extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	calculate_and_apply(GameManager.instance.max_hp)
func deactivate():
	super()
	Statics.player_shield_buff -= curr_buff_applied
	curr_buff_applied = 0
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

const hp_percent_buff: float = 0.15
var curr_buff_applied: float = 0

func calculate_and_apply(max_hp: float):
	## Remove old
	Statics.player_shield_buff -= curr_buff_applied
	## Add new
	curr_buff_applied = hp_percent_buff * max_hp
	Statics.player_shield_buff += curr_buff_applied

func player_maxhp_changed(new_maxhp: float, old_maxhp: float):
	calculate_and_apply(new_maxhp)
	super(new_maxhp, old_maxhp)
