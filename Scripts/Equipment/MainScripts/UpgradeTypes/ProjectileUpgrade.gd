extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Projectiles
class_name ProjectileUpgrade
enum TargetSelectionTypes {Closest, Random, MostHp, Farthest}
@export var target_selection: TargetSelectionTypes = TargetSelectionTypes.Closest
func _process(delta: float) -> void:
	super(delta)
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
	## Spawn for count
	for i in UpgradeStatics.projectile_count_buff + additional_spawns:
		if super():
			UpgradeStatics.active_projectiles += 1
			spawned_successfully = true
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
		projectile.setup_projectile(self, enemy, (enemy.global_position - player.global_position).normalized(), false, 0)
	else: ## Random Direction, no homing
		projectile.setup_projectile(self, null, get_global_mouse_position() - player.global_position, false, 0)
	projectile.setup_death_method(despawn)
	return projectile
## Overrides
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position
	return spawn_position
func get_spawning_duration() -> float:
	return super() + UpgradeStatics.projectile_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
