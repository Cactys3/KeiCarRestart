extends Character

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
func _physics_process(delta: float) -> void:
	super(delta)
## Abilities
var boxing_stance_buff_duration: float = 10
var boxing_stance_buff_stopwatch: float = 0
var boxing_stance_buff_applied: bool = false
func trigger_ability1():
	super()
	## Boxing Stance: Gain the buff
	boxing_stance_buff_stopwatch = boxing_stance_buff_duration
	## TODO: apply buff
	boxing_stance_buff_applied = true
func trigger_ability2():
	super()
	## Combust: Spawn a blow up projectile/trap
func trigger_ability3():
	super()
	## ??
## Override to give abilities access to process method
func handle_abilities(delta: float) -> void:
	if boxing_stance_buff_stopwatch > 0:
		boxing_stance_buff_stopwatch -= delta
	elif boxing_stance_buff_applied:
		## TODO: remove buff
		boxing_stance_buff_applied = false
