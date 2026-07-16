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
func spawn() -> void:
	## Spawn One
	if !can_spawn_multiple:
		super()
	## Spawn Multiple
	else:
		var spawn_count: float = max(1, 1 + count_stat + additional_spawns)
		for i in spawn_count:
			super()
func despawn():
	Statics.active_traps -= 1
## Override to setup spawn
func initialize_object(object: Node2D, parent: Node2D, spawn_position: Vector2) -> void:
	if object is Trap:
		object.setup(self, get_attack_source())
		super(object, parent, spawn_position)
func on_spawn():
	Statics.active_traps += 1
	super()
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	return spawn_position
func get_spawning_duration() -> float:
	return super() + Statics.trap_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.trap
