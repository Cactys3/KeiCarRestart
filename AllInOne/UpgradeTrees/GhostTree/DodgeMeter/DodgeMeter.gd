extends MeterUpgrade
func activate(new_player: Character):
	connect_dodge = true
	super(new_player)
func deactivate():
	super()
func edit_attack(attack: Attack) -> Attack:
	return attack
func edit_stats():
	pass
func remove_buff():
	pass
## This upgrade does: 
# Each time you dodge, fill up a ghostly meter.
# Resets on taking damage.
# At max meter, gain damage and movespeed.
const dodge_meter_max: float = 100
const dodge_meter_gain_per_dodge: float = 10
var curr_dodge_meter: float = 0
var stopwatch: float = 0
func dodge(character: Character, attack: Attack):
	curr_dodge_meter += dodge_meter_gain_per_dodge
func _process(delta: float) -> void:
	curr_dodge_meter -= delta
	#stopwatch += delta TODO: Implement Meter
	#if stopwatch >= 0.5:
		#stopwatch = 0
		#game_man.ui_man.set_meter(meter, curr_dodge_meter
