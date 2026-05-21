extends Enemy
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
## Revive
func die():
	if sound_on_death:
		AudioManager.instance.play(sound_on_death, global_position)
	if curr_health < 100:
		print("Dummy Revive")
		curr_health += 1000
## Don't death signal
func death_signal(attack: Attack):
	pass
