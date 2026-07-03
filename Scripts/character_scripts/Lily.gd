extends Character

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func _physics_process(delta: float) -> void:
	super(delta)
## Abilities
const boxing_stance_duration: int = 5
func trigger_ability1():
	super()
	## Boxing Stance: Gain the buff
	apply_ability_buff_1()
func trigger_ability2():
	super()
	## Combust: Spawn a blow up projectile/trap
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
	ability_buff_1_duration = boxing_stance_duration
	ability_buff_2_duration = 0
func get_ability1_cooldown() -> float:
	return 0
func get_ability2_cooldown() -> float:
	return 0
func get_ability3_cooldown() -> float:
	return 0
