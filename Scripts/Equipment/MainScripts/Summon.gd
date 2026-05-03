extends SpawnObject
class_name Summon

## Orbit player/have movement
## Attacking enemy mode
# Two modes? One whilst attacking enemy one whilst not attacking
enum AimTypes{default, DynamicAtMouse, AlwaysAtMouse, StaticSlot, Spinning, Unique}
@export var AimType: AimTypes = AimTypes.default

func _process(delta: float) -> void:
	pass
