extends Upgrade
## Adds functionality to Upgrade that spawns an object and provides and override function to init it
class_name SpawningUpgrade
@export var spawn_on_enemy_kills: bool = false
@export var enemy_kills_to_spawn: int = 0
@export var spawn_on_reload: bool = false
@export var spawn_with_cd: bool = false
@export var create_radial_ui_for_cd: bool = true
@export var spawn_every_seconds: float = 0
@export var scene_to_spawn: PackedScene
@export var spawn_radius: float = 40
@export var spawn_duration: float = 10
@export var sound_on_spawn: Sound = null
@export var can_spawn_multiple: bool = true
static var spawn_every_seconds_cd_reduction_factor: float = 1
static var spawn_on_enemy_kills_reduction_factor: float = 1
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
	if !disabled_by_inherited_upgrade:
		if spawn_on_enemy_kills:
			if enemies_killed_since_spawn >= (enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor) && spawn():
				enemies_killed_since_spawn -= int(enemy_kills_to_spawn * spawn_on_enemy_kills_reduction_factor)
		elif spawn_on_reload:
			if reloads_since_last_spawn > 0 && spawn():
				reloads_since_last_spawn -= 1
		elif spawn_with_cd:
			stopwatch += delta
			var spawned: bool = false
			if stopwatch >= (spawn_every_seconds * spawn_every_seconds_cd_reduction_factor) && spawn():
				stopwatch = 0
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
## Enables the functionality of this upgrade
func activate(new_player: Character):
	if spawn_on_reload:
		connect_reload = true
	if spawn_on_enemy_kills:
		connect_enemy_killed = true
	if spawn_with_cd && create_radial_ui_for_cd:
		setup_cooldown_ui()
	super(new_player)
	spawn()
func deactivate():
	kill_cooldown_ui()
	super()
## Creates the object, initializes it, returns success
func spawn() -> bool:
	if scene_to_spawn:
		var object = scene_to_spawn.instantiate()
		if initialize_object(object):
			if sound_on_spawn:
				AudioManager.instance.play(sound_on_spawn, global_position)
			reloads_since_last_spawn = 0
			return true
	return false
## Override to setup the spawned object
func initialize_object(object: Node2D) -> bool:
	get_spawn_parent().add_child(object)
	object.global_position = get_spawning_position()
	return true
func reload(weapon: Weapon) -> void:
	super(weapon)
	reloads_since_last_spawn += 1
func enemy_killed(enemy: Enemy, attack: Attack) -> void:
	super(enemy, attack)
	enemies_killed_since_spawn += 1
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
	cooldownUI = preload("uid://brjmxsn8spmpe").instantiate()
	GameManager.instance.ui_man.hud.add_upgrade_cooldown_ui(cooldownUI)
	cooldownUI.setup(item_name + " cd", Color.BLACK, item_image)
func kill_cooldown_ui():
	if cooldownUI != null:
		cooldownUI.kill()
