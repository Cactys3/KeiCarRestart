extends StatsObject
class_name Ability
## Make sure to override to set correct type
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.unset
func get_attack_source() -> Attack.AttackSources:
	return Attack.AttackSources.ability
func _ready() -> void:
	super()
func _process(delta: float) -> void:
	super(delta)
