extends Upgrade
## Adds functionality to Upgrade that spawns an object and provides and override function to init it
class_name SpawningUpgrade
@export var spawn_on_enemy_kills: bool = false
@export var enemy_kills_to_spawn: int = 0
@export var spawn_on_reload: bool = false
@export var spawn_every_x_reloads: int = 1
@export var spawn_with_projectiles: bool = false
@export var spawn_every_x_projectiles: int = 5
@export var spawn_with_cd: bool = false
@export var create_radial_ui_for_cd: bool = true
@export var spawn_every_seconds: float = 0
@export var scene_to_spawn: PackedScene
@export var spawn_radius: float = 40
@export var spawn_duration: float = 10
@export var sound_on_spawn: Sound = null
## Do we Consider 'Count' Stat? (spawn multiple spawns per spawn)
@export var can_spawn_multiple: bool = true
static var spawn_every_seconds_cd_reduction_factor: float = 1
static var spawn_on_enemy_kills_reduction_factor: float = 1
var projectiles_since_last_spawn: int = 0
var reloads_since_last_spawn: int = 0
var enemies_killed_since_spawn: int = 0
var stopwatch: float = 0
var cooldownUI_stopwatch: float = 0
var cooldownUI: CooldownUI
## Additional Spawns for only this SpawningUpgrade
var additional_spawns: int = 0
func _ready() -> void:
	super()
## Spawn the object from 'scene_to_spawn' every spawn_every_seconds seconds
func _process(delta: float) -> void:
	super(delta)
	if !disabled_by_inherited_upgrade && active:
		if spawn_on_enemy_kills:
			if enemies_killed_since_spawn >= (enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor):
				spawn()
				enemies_killed_since_spawn -= int(enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor)
		if spawn_on_reload:
			if reloads_since_last_spawn >= spawn_every_x_reloads:
				reloads_since_last_spawn -= spawn_every_x_reloads
				spawn()
		if spawn_with_cd:
			stopwatch += delta
			var spawned: bool = false
			if stopwatch >= (spawn_every_seconds * spawn_every_seconds_cd_reduction_factor):
				spawn()
				stopwatch = 0
				emit_cooldown_finished()
				spawned = true
			## Every x sec, update cd UI
			if cooldownUI != null:
				if cooldownUI_stopwatch >= 0.05:
					cooldownUI_stopwatch = 0
					if spawned:
						cooldownUI.set_progress(1)
					else:
						cooldownUI.set_progress(stopwatch / spawn_every_seconds)
				else:
					cooldownUI_stopwatch += delta
		if spawn_with_projectiles:
			if projectiles_since_last_spawn >= spawn_every_x_projectiles:
				projectiles_since_last_spawn -= spawn_every_x_projectiles
				spawn()
## Enables the functionality of this upgrade
func activate(new_player: Character):
	if spawn_on_reload:
		connect_reload = true
	if spawn_on_enemy_kills:
		connect_enemy_killed = true
	if spawn_with_cd && create_radial_ui_for_cd:
		setup_cooldown_ui()
	if spawn_with_projectiles:
		connect_projectile_spawned = true
	super(new_player)
	spawn()
func deactivate():
	kill_cooldown_ui()
	super()
## Creates the object, initializes it, returns success
func spawn() -> void:
	if scene_to_spawn:
		var object = scene_to_spawn.instantiate()
		initialize_object(object, get_spawn_parent(), get_spawning_position())
	else:
		printerr("No Scene To Spawn On Upgrade: ", data.upgrade_name)
## Setup the object to spawn in the game (carryout spawning)
func initialize_object(object: Node2D, parent: Node2D, spawn_position: Vector2) -> void:
	parent.add_child(object)
	object.global_position = spawn_position
	edit_spawn_object(object)
	on_spawn()
## Preform actions that happen on spawn genericly
func on_spawn():
	if sound_on_spawn:
		AudioManager.instance.play(sound_on_spawn, global_position)
## Preform actions that happen to spawn objects when they are spawned (custom overrides)
func edit_spawn_object(object: SpawnObject):
	pass
func reload(weapon: Weapon) -> void:
	super(weapon)
	reloads_since_last_spawn += 1
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	super(enemy, attack)
	enemies_killed_since_spawn += 1
func projectile_spawned(projectile: Projectile):
	super(projectile)
	projectiles_since_last_spawn += 1
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	return spawn_position
func get_spawning_duration() -> float:
	return spawn_duration + duration_stat + Statics.spawn_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
func setup_cooldown_ui():
	if cooldownUI != null:
		kill_cooldown_ui()
	cooldownUI = GameManager.instance.ui_man.setup_cooldown_ui(true, false, item_name + " cd", Color.BLACK, item_image)
	cooldownUI.set_progress(0)
func kill_cooldown_ui():
	if cooldownUI != null:
		cooldownUI.kill()
