extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Creations
class_name CreationUpgrade
var active_creations: Array[Creation] = []
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
		UpgradeStatics.active_creations += 1
	## Spawn for count
	for i in UpgradeStatics.creation_count_buff + additional_spawns:
		if super():
			UpgradeStatics.active_creations += 1
func despawn():
	UpgradeStatics.active_creations -= 1
## Override to setup spawn
func initialize_object(object: Node2D) -> bool:
	if object is Creation: 
		object = object as Creation
		object.setup(self, get_spawning_duration())
		active_creations.append(object)
		return super(object)
	return false
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	return spawn_position
func get_spawning_duration() -> float:
	return super() + UpgradeStatics.creation_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
