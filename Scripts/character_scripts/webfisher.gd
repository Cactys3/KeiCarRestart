extends Character

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func _physics_process(delta: float) -> void:
	super(delta)
## Abilities
func trigger_ability1():
	super()
	## ??
func trigger_ability2():
	super()
	## ??
func trigger_ability3():
	super()
	## ??
## Override to give abilities access to process method
func handle_abilities(delta: float) -> void:
	super(delta)
func apply_ability_buff_1():
	super()
func apply_ability_buff_2():
	super()
func remove_ability_buff_1():
	super()
func remove_ability_buff_2():
	super()
func setup_ability_variables():
	ability_buff_1_duration = 0
	ability_buff_2_duration = 0
func get_ability1_cooldown() -> float:
	return 0
func get_ability2_cooldown() -> float:
	return 0
func get_ability3_cooldown() -> float:
	return 0
