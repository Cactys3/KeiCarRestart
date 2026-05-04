extends Upgrade
## Adds functionality to Upgrade that spawns an object and provides and override function to init it
class_name SpawningUpgrade
@export var spawn_on_enemy_kills: bool = false
@export var enemy_kills_to_spawn: int = 0
@export var spawn_on_reload: bool = false
@export var spawn_with_cd: bool = false
@export var spawn_every_seconds: float = 0
@export var scene_to_spawn: PackedScene
@export var spawn_radius: float = 40
@export var spawn_duration: float = 10
static var spawn_every_seconds_cd_reduction_factor: float = 1
static var spawn_on_enemy_kills_reduction_factor: float = 1
var reloads_since_last_spawn: int = 0
var enemies_killed_since_spawn: int = 0
var stopwatch: float = 0
## Additional Spawns for only this SpawningUpgrade
var additional_spawns: int = 0
func _ready() -> void:
	super()
## Spawn the object from 'scene_to_spawn' every spawn_every_seconds seconds
func _process(delta: float) -> void:
	super(delta)
	if !disabled_by_inherited_upgrade:
		if spawn_on_enemy_kills:
			if enemies_killed_since_spawn >= (enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor) && spawn():
				enemies_killed_since_spawn -= int(enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor)
		elif spawn_on_reload:
			if reloads_since_last_spawn > 0 && spawn():
				reloads_since_last_spawn -= 1
		elif spawn_with_cd:
			stopwatch += delta
			if stopwatch >= (spawn_every_seconds * spawn_every_seconds_cd_reduction_factor) && spawn():
				stopwatch = 0
## Enables the functionality of this upgrade
func activate(new_player: Character):
	if spawn_on_reload:
		connect_reload = true
	if spawn_on_enemy_kills:
		connect_enemy_killed = true
	super(new_player)
## Creates the object, initializes it, returns success
func spawn() -> bool:
	var object = scene_to_spawn.instantiate()
	if initialize_object(object):
		print("spawn one")
		reloads_since_last_spawn = 0
		return true
	return false
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	#object.global_position = get_spawning_position()
	#get_spawn_parent().add_child(object)
	return false
## Get a random position using "spawn radius"
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	print("position: ", spawn_position)
	return spawn_position
func get_spawning_duration() -> float:
	return spawn_duration + duration_stat + UpgradeStatics.spawn_duration_buff
func reload(weapon: Weapon) -> void:
	super(weapon)
	reloads_since_last_spawn += 1
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	super(enemy, attack)
	enemies_killed_since_spawn += 1
## Returns gamemanager's projectile_parent or override
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
