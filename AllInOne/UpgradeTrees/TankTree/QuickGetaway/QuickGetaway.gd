extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	super(new_player)
	Statics.player_stance_buff += stance_stat_buff
func deactivate():
	super()
	Statics.player_stance_buff -= stance_stat_buff
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
	Statics.player_movespeed_buff += movespeed_buff
func remove_buff():
	Statics.player_movespeed_buff -= movespeed_buff
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)

func player_damaged(character: Character, attack: Attack):
	add_to_buff_time(buff_time_on_damage)
	apply_buff()

const movespeed_buff: float = 0.2
const stance_stat_buff: float = 5
const buff_time_on_damage: float = 2
