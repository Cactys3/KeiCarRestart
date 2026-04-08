extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Creations
class_name CreationUpgrade
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
	UpgradeStatics.active_creations += 1
	## Spawn for count
	for i in UpgradeStatics.creation_count:
		super()
func despawn():
	UpgradeStatics.active_creations -= 1
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	return false
