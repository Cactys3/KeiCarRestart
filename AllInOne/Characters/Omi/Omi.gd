extends Character

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func _physics_process(delta: float) -> void:
	super(delta)
### Abilities
#func trigger_ability1():
	#super()
	### Swing a chain sickle around you, damaging and massively slowing enemies
#const shuuchuu_duration: float = 3
#func trigger_ability2():
	#super()
	### Gain 5 additional ammo and 50% attackspeed for a duration
	#apply_ability_buff_1()
#func trigger_ability3():
	#super()
	### Throw down a smoke bomb, damaging enemies and causing them to lose track of you for a duration.
	### During this, you can move through enemies and have increased movespeed.
### Override to give abilities access to process method
#func handle_abilities(delta: float) -> void:
	#super(delta)
#func apply_ability_buff_1():
	#super()
#func apply_ability_buff_2():
	#super()
#func remove_ability_buff_1():
	#super()
#func remove_ability_buff_2():
	#super()
#func setup_ability_variables():
	#ability_buff_1_duration = shuuchuu_duration
	#ability_buff_2_duration = 0
func get_ability1_cooldown() -> float:
	return 30
func get_ability2_cooldown() -> float:
	return 10
func get_ability3_cooldown() -> float:
	return 80
