extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Traps
class_name TrapUpgrade
func _process(delta: float) -> void:
	super(delta)
## Enables the functionality of this upgrade
func activate(new_player: Character):
	spawn()
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	despawn()
	super()
func spawn():
	UpgradeStatics.active_traps += 1
	super()
func despawn():
	UpgradeStatics.active_traps -= 1
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	return false
