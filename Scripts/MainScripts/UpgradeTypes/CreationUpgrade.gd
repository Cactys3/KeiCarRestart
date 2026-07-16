extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Creations
class_name CreationUpgrade
@export var multiple_spawns_type: MultipleSpawnsTypes = MultipleSpawnsTypes.delay
enum MultipleSpawnsTypes{delay, same_time}
var active_creations: Array[Creation] = []
func _process(delta: float) -> void:
	super(delta)
	if !disabled_by_inherited_upgrade && active:
		pass
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
		Statics.active_creations += 1
	## Spawn Multiple
	else:
		var spawns_left: float = max(1, 1 + count_stat + additional_spawns)
		match multiple_spawns_type:
			MultipleSpawnsTypes.delay:
				## Wait inbetween spawning creations (0.1 sec minimum)
				var delay: float = max(0.1, attackcooldown_stat)
				for i in spawns_left:
					super()
					Statics.active_creations += 1
					await get_tree().create_timer(delay, false).timeout
			MultipleSpawnsTypes.same_time:
				## Spawn all creations at once
				super()
				Statics.active_creations += 1

func despawn():
	Statics.active_creations -= 1
## Override to setup spawn
func initialize_object(object: Node2D, parent: Node2D, spawn_position: Vector2) -> void:
	if object is Creation: 
		object = object as Creation
		object.setup(self, get_spawning_duration())
		active_creations.append(object)
		super(object, parent, spawn_position)
	else:
		printerr("Creation Upgrade Scene Is Not Of Type Creation")
		push_error("Creation Upgrade Scene Is Not Of Type Creation")
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	return spawn_position
func get_spawning_duration() -> float:
	return super() + Statics.creation_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.creation
