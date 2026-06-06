extends Upgrade
## This upgrade:
# Gain 20 additional health points
func activate(new_player: Character):
	super(new_player)
	Statics.player_hp_buff += hp_buff
	Statics.player_regen_buff += regen_buff
func deactivate():
	Statics.player_hp_buff -= hp_buff
	Statics.player_regen_buff -= regen_buff
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

const hp_buff: float = 20
const regen_buff: float = 4
