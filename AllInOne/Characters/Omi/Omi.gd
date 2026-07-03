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
	pass
