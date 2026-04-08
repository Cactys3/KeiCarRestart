extends SpawningUpgrade
## Adds functionality to Upgrade that adds a Summon which follows the player and damages enemies
class_name SummonUpgrade
var spawned: bool = false
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
	UpgradeStatics.active_summons += 1
	## Spawn for count
	for i in UpgradeStatics.summon_count:
		super()
	spawned = true
func despawn():
	UpgradeStatics.active_summons -= 1
	spawned = false
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	return false
