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
	## If we spawn, increase active spawn counter
	if super():
		UpgradeStatics.active_traps += 1
	## Spawn for count
	for i in UpgradeStatics.trap_count_buff + additional_spawns:
		if super():
			UpgradeStatics.active_traps += 1
func despawn():
	UpgradeStatics.active_traps -= 1
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	if object is Trap: ## object is Trap:
		return true
	return false

## Add in creation duration buff
func get_spawning_duration() -> float:
	return super() + UpgradeStatics.trap_duration_buff
