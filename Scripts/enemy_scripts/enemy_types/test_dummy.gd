extends Enemy
func _ready() -> void:
	super()
func _process(delta) -> void:
	super(delta)
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
