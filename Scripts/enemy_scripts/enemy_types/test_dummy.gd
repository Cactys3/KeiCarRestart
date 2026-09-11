extends Enemy
func _ready() -> void:
	super()
## Revive
func die():
	if sound_on_death:
		AudioManager.instance.play(sound_on_death, global_position)
	if curr_health < 100:
		print("Dummy Revive")
		curr_health += 1000
		burn_threshhold = 1
		frost_threshhold = 1
		poison_threshhold = 1
		bleed_threshhold = 1
		shock_threshhold = 1
		wet_threshhold = 1
		burn = 0
		frost = 0
		poison = 0
		bleed = 0
		shock = 0
		wet = 0
		applied_burn = 0
		applied_frost = 0
		applied_poison = 0
		applied_bleed = 0
		applied_shock = 0
		applied_wet = 0
## Don't death signal
func death_signal(attack: Attack):
	pass

var dps_array: Array[DPS]
var damage_past_ten_sec: float = 0
func damage(attack: Attack) -> DamageReturn:
	var prehealth = curr_health
	var ret = super(attack)
	var posthealth = curr_health
	var difference = prehealth - posthealth
	if difference > 0:
		dps_array.append(DPS.new(10, difference, dps_array))
		damage_past_ten_sec += difference
	return ret

var stopwatch: float = 0
func _process(delta) -> void:
	super(delta)
	for dps in dps_array:
		dps.process(delta)
		if dps.countdown < 0:
			dps_array.erase(dps)
	if stopwatch > 1:
		## TODO: Update DPS Visual
		var average: float = 0
		var count: float = 0
		for dps in dps_array:
			average += dps.damage
			count += 1
			#print("Num ", count, " is: ", dps.damage, " for total: ", average, " average: ", average / 10)
		furry(average / 10, Color.WHITE)
		stopwatch = 0
	else:
		stopwatch += delta

func furry(dps: float, color: Color):
	var dmg_text: PopupText = load("uid://brldrnbhcexcm").instantiate()
	dmg_text.global_position = Vector2.ZERO
	var text: String = str("DPS: ", dps)
	#print("text: ", text, " dps, ", dps)
	var size: float = dps + randi_range(-5, 5)
	var location: Vector2 = WindowManager.instance.convert_small_position(global_position - Vector2(0, 10))
	var lifetime: float = 1
	var random_location_range: Vector2 = Vector2(0, 0)
	if color == Color.TRANSPARENT:
		dmg_text.setup(text, size, location, lifetime, random_location_range)
	else:
		dmg_text.setup_color(text, size, location, lifetime, random_location_range, color)

class DPS:
	var damage: float = 0
	var countdown: float = 10
	var array: Array
	func _init(lifetime: float, new_damage: float, new_array: Array):
		print("co: ", countdown)
		countdown = lifetime
		damage = new_damage
	func process(delta: float):
		countdown -= delta
