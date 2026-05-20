extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Projectiles
class_name ProjectileUpgrade
enum TargetSelectionTypes {Closest, Random, MostHp, Farthest}
@export var target_selection: TargetSelectionTypes = TargetSelectionTypes.Closest
@export var multiple_spawns_type: MultipleSpawnsTypes = MultipleSpawnsTypes.delay_hard_coded
enum MultipleSpawnsTypes{delay_hard_coded, delay_stats, spread}
## Radius around the spawn position that spread spawns will be spawned
@export var spread_offset_radius: float
@export var delay_spawns_cooldown: float = 0.5
var delay_spawns_stopwatch: float = 0
var delay_spawns_left: int = 0
var spread_offset: Vector2 = Vector2(0, 0)
func _process(delta: float) -> void:
	super(delta)
	## 
	if delay_spawns_left > 0:
		delay_spawns_stopwatch += delta
		if delay_spawns_stopwatch >= delay_spawns_cooldown && super.spawn():
			## Reset
			delay_spawns_stopwatch = 0
			delay_spawns_left -= 1
			#print_debug(delay_spawns_left, " left")
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	despawn()
	super()
func spawn() -> bool:
	var spawned_successfully: bool = false
	## If we spawn, increase active spawn counter
	if super():
		UpgradeStatics.active_projectiles += 1
		spawned_successfully = true
	## Spawn Multiple:
	var spawn_count = UpgradeStatics.projectile_count_buff + additional_spawns
	match multiple_spawns_type:
		MultipleSpawnsTypes.delay_hard_coded:
			## Delay hard-coded
			delay_spawns_stopwatch = 0
			delay_spawns_left += spawn_count
		MultipleSpawnsTypes.delay_stats:
			## Delay but based on stats
			delay_spawns_stopwatch = 0
			delay_spawns_cooldown = attackcooldown_stat
			delay_spawns_left += spawn_count
		MultipleSpawnsTypes.spread:
			## Spawn all at once with offsets
			for i in spawn_count:
				spread_offset = Vector2(randf_range(-spread_offset_radius, spread_offset_radius), randf_range(-spread_offset_radius, spread_offset_radius))
				if super():
					UpgradeStatics.active_projectiles += 1
					spawned_successfully = true
			spread_offset = Vector2(0, 0)
	return spawned_successfully
func despawn():
	UpgradeStatics.active_projectiles -= 1
func initialize_object(object: Node2D) -> bool:
	if object is Projectile:
		var projectile: Projectile = initialize_projectile(object as Projectile)
		projectile.setup_death_method(despawn)
		return super(object)
	return false
func initialize_projectile(projectile: Projectile) -> Projectile:
	var enemy: Node2D ## TODO: Target Selection
	match target_selection:
		TargetSelectionTypes.Closest:
			enemy = get_nearest_enemy()
		TargetSelectionTypes.Farthest:
			enemy = get_nearest_enemy()
		TargetSelectionTypes.Random:
			enemy = get_nearest_enemy()
		TargetSelectionTypes.MostHp:
			enemy = get_nearest_enemy()
		_:
			enemy = get_nearest_enemy()
	if enemy:
		projectile.setup_projectile(self, enemy, (enemy.global_position - player.global_position).normalized())
	else: ## Random Direction, no homing
		projectile.setup_projectile(self, null, get_global_mouse_position() - player.global_position)
	projectile.setup_death_method(despawn)
	return projectile
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + spread_offset
	return spawn_position
func get_spawning_duration() -> float:
	return super() + UpgradeStatics.projectile_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
