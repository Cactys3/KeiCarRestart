extends Upgrade
## Upgrade that adds and maintains a meter
class_name MeterUpgrade
## Can't Gain Meter While This is Above 0
var no_meter_gain_for_seconds: float = 0
var meter: GrowBar
var meter_color: Color = Color.RED
var meter_loss_per_second: float = 0
var curr_value: float = 0
const max_value: float = 100
signal meter_changed(curr: float, max_value: float)
func _process(delta: float) -> void:
	super(delta)
	if no_meter_gain_for_seconds > 0:
		no_meter_gain_for_seconds -= delta
	else:
		no_meter_gain_for_seconds = 0
	curr_value -= delta * meter_loss_per_second
## Enables the functionality of this upgrade
func activate(new_player: Character):
	## Should be first so we disable upgrades/get variables from disabled upgrades before setting up meter
	super(new_player)
	meter = GameManager.instance.ui_man.hud.add_upgrade_bar_ui(meter_color)
	meter.set_value_percent(0)
## Disables the functionality of this upgrade
func deactivate():
	super()
func remove_buff():
	super()
func apply_buff():
	super()
## Returns if successful
func add_to_meter(value: float) -> bool:
	## meter can go down but not up
	if value < 0 || no_meter_gain_for_seconds <= 0:
		_change_meter(curr_value + value)
		return true
	return false
## Percent from 0 to 1
func spend_percent_of_max_meter(percent: float) -> bool:
	if curr_value >= max_value * percent:
		_change_meter(-(max_value * percent))
		return true
	return false
## backend - Override to do things based on meter values
func _change_meter(new_value: float) -> void:
	curr_value += new_value
	if curr_value > max_value:
		curr_value = max_value
		max_meter()
	elif curr_value < 0:
		curr_value = 0
	meter.set_value_percent(curr_value / max_value)
	meter_changed.emit(curr_value, max_value)
## curr_value >= max_value
func max_meter():
	pass
