extends Upgrade
## This upgrade:
#
func activate(new_player: Character):
	DodgeMeter = find_upgrade(sought_upgrade)
	if !DodgeMeter:
		printerr("Couldn't find upgrade: ", sought_upgrade)
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
	add_to_buff_time(buff_duration)
	Statics.player_movespeed_factor += movespeed_buff
	Statics.player_ghostly_buff += ghostly_buff
	super()
func remove_buff():
	Statics.player_movespeed_factor -= movespeed_buff
	Statics.player_ghostly_buff -= ghostly_buff
	super()
func _process(delta: float) -> void:
	super(delta)
func upgrade_cooldown_finished(upgrade: Upgrade):
	super(upgrade)
func custom_input_just_pressed():
	super()
	if DodgeMeter && DodgeMeter.spend_percent_of_max_meter(activate_meter_cost):
		apply_buff()

var DodgeMeter: MeterUpgrade
## 100% = 1
const activate_meter_cost: float = 1
const sought_upgrade: String = "Procrastination"
const movespeed_buff: float = 1
const ghostly_buff: float = 100
const buff_duration: float = 5
