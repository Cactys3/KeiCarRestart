extends ProjectileUpgrade

var blood_meter: MeterUpgrade
var meter_full: bool = false
var meter: GrowBar
var BLOOD_METER_NAME: String = "Blood Meter"
const meter_gain_time_penalty: float = 2
func activate(new_player: Character):
	super(new_player)
	var blood_meter_upgrade: MeterUpgrade = find_upgrade(BLOOD_METER_NAME)
	if blood_meter_upgrade == null:
		printerr("Hemoplosion can't find blood meter")
	else:
		## Get info from BloodMeter
		blood_meter = blood_meter_upgrade
		meter = blood_meter.meter
		blood_meter.meter_changed.connect(meter_changed)
		
		blood_meter.add_to_meter(100)
		
		meter_full = blood_meter.curr_value >= blood_meter.max_value
	## Get keybind ## TODO: Get Keybind

func deactivate():
	super()
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
	if blood_meter && meter_full && Input.is_action_just_pressed(assigned_input):
		if blood_meter.spend_percent_of_max_meter(1):
			explode()
## Spawn an explosion on the player
func explode():
	meter_full = false
	blood_meter.no_meter_gain_for_seconds = meter_gain_time_penalty
	spawn()
	print("explode")
func get_spawning_position() -> Vector2:
	return GameManager.instance.player.global_position
func meter_changed(curr: float, max_value: float):
	meter_full = curr >= max_value
