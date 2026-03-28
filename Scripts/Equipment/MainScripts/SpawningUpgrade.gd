extends Upgrade
## Adds functionality to Upgrade that spawns an object and provides and override function to init it
class_name SpawningUpgrade
@export var spawn_on_enemy_kills: bool = false
@export var enemy_kills_to_spawn: int = 0
@export var spawn_on_reload: bool = false
@export var spawn_with_cd: bool = false
@export var spawn_every_seconds: float = 0
static var spawn_every_seconds_cd_reduction_factor: float = 1
static var spawn_on_enemy_kills_reduction_factor: float = 1
var scene_to_spawn: PackedScene
var reloads_since_last_spawn: int = 0
var enemies_killed_since_spawn: int = 0
var stopwatch: float = 0
func _ready() -> void:
	if spawn_on_reload:
		connect_reload = true
	if spawn_on_enemy_kills:
		connect_enemy_killed = true
	super()
## Spawn the object from 'scene_to_spawn' every spawn_every_seconds seconds
func _process(delta: float) -> void:
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
func spawn() -> bool:
	var object = scene_to_spawn.instantiate()
	if initialize_object(object):
		GameManager.instance.projectile_parent.add_child(object)
	return false
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	return true
func reload() -> void:
	super()
	reloads_since_last_spawn += 1
func enemy_killed() -> void:
	super()
	enemies_killed_since_spawn += 1
