extends Summon

func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)

## Called by upgrade, doesn't rely on cooldowns and other attack vars
func throw_spear_at_enemy(enemy: Enemy):
	pass ## TODO: throw spear
