extends SpawningUpgrade
## Spawning Upgrade that specifically spawns Projectiles
class_name ProjectileUpgrade
enum TargetSelectionTypes {Closest, Random, MostHp, Farthest, TowardsMouse, TowardsMovement, NoTarget}
@export var target_selection: TargetSelectionTypes = TargetSelectionTypes.Closest
@export var infinite_range_stat: bool = false
enum MultipleProjectilesAimTypes {random, spread}
@export var multiple_projectiles_aim: MultipleProjectilesAimTypes = MultipleProjectilesAimTypes.spread
## Radius around the spawn position that spread spawns will be spawned
@export var random_offset_radius: float = 15
@export var MultipleProjectileOffset: float = 2
@export var MultipleProjectileAngleOffset: float = 2
var delay_spawns_stopwatch: float = 0
var delay_spawns_left: int = 0
var spread_offset: Vector2 = Vector2(0, 0)
func _process(delta: float) -> void:
	super(delta)
	if !disabled_by_inherited_upgrade && active:
		pass
## Enables the functionality of this upgrade
func activate(new_player: Character):
	super(new_player)
## Disables the functionality of this upgrade
func deactivate():
	despawn()
	super()

func spawn() -> void:
	## Spawn One
	if !can_spawn_multiple:
		super()
		Statics.active_projectiles += 1
	## Spawn Multiple
	else:
		var ammo_left: float = 1 + ammo_stat
		## Wait inbetween spawning projectiles (0.1 sec minimum)
		var delay: float = max(0.1, attackcooldown_stat)
		for i in ammo_left:
			spread_offset = Vector2.ZERO
			var spawns_left: int = max(1, 1 + count_stat + additional_spawns)
			match multiple_projectiles_aim:
				MultipleProjectilesAimTypes.spread:
					## Spread aim from aim direction
					var target: Node2D = get_spawn_target()
					## Spawn one to be in the center first
					super()
					## Then spawn the rest with spread
					create_num_projectiles(spawns_left - 1, target)
				MultipleProjectilesAimTypes.random:
					## Random Projectile Spawns Towards Direction
					for j in spawns_left:
						super()
						Statics.active_projectiles += 1
						spread_offset = Vector2(randf_range(-random_offset_radius, random_offset_radius), randf_range(-random_offset_radius, random_offset_radius))
					spread_offset = Vector2.ZERO
			## Wait between Ammos
			await get_tree().create_timer(delay, false).timeout

func create_num_projectiles(count: int, target: Node2D):
	var proj_offset: int = 0
	## Create projectiles based on count with offset angles and position
	for i in count:
		var projectile_position: Vector2 = get_spawning_position()
		var projectile_direction: Vector2 = get_spawning_direction(target)
		## Make two projectiles with each offset value at -1 and +1 signs, then increase offset
		if i % 2  == 0:
			proj_offset += 1
		MultipleProjectileOffset *= -1
		MultipleProjectileAngleOffset *= -1
		## Offset projectile by position + [1 unit to the Left of default position] * [Positive offset to keep it left, negative to make it right] * [magnitude offset]
		projectile_position += (Vector2(-sin(projectile_direction.angle()), cos(projectile_direction.angle())) * MultipleProjectileOffset * proj_offset)
		## Get Direction offset by inaccuracy
		var x = cos(projectile_direction.angle() + deg_to_rad(proj_offset * MultipleProjectileAngleOffset))
		var y = sin(projectile_direction.angle() + deg_to_rad(proj_offset * MultipleProjectileAngleOffset))
		projectile_direction = Vector2(x, y)
		## Carryout 'Spawn' and 'Initialize_object'
		var projectile: Projectile = scene_to_spawn.instantiate()
		get_spawn_parent().add_child(projectile)
		projectile.global_position = projectile_position
		projectile.setup_projectile(self, get_attack_source(), target, projectile_direction)
		edit_spawn_object(projectile)
		on_spawn()

func despawn():
	Statics.active_projectiles -= 1
func initialize_object(object: Node2D, parent: Node2D, spawn_position: Vector2) -> void:
	if object is Projectile:
		var projectile: Projectile = initialize_projectile(object as Projectile)
		super(projectile, parent, spawn_position)
	else:
		printerr("Projectile Upgrade Scene Is Not Of Type Projectile")
		push_error("Projectile Upgrade Scene Is Not Of Type Projectile")
func initialize_projectile(projectile: Projectile) -> Projectile:
	var target: Node2D = get_spawn_target()
	projectile.setup_projectile(self, get_attack_source(), target, get_spawning_direction(target))
	projectile.setup_death_method(despawn)
	return projectile
## Overrides
func get_spawning_direction(target: Node2D) -> Vector2:
	## Target Selection Cases
	match target_selection:
		TargetSelectionTypes.TowardsMouse:
			return make_inaccurate_direction((get_global_mouse_position() - player.global_position).normalized())
		TargetSelectionTypes.TowardsMovement:
			if player.last_known_velocity != Vector2.ZERO:
				return make_inaccurate_direction(player.last_known_velocity)
	## Run through priorities (target -> movement -> mouse)
	## Is Target Valid
	if target:
		var direction = (target.global_position - player.global_position).normalized()
		if direction != Vector2.ZERO:
			return make_inaccurate_direction(direction)
	## Return Direction from Player to Mouse
	if (get_global_mouse_position() - player.global_position).normalized() != Vector2.ZERO:
		return make_inaccurate_direction((get_global_mouse_position() - player.global_position).normalized())
	## Return Direction Player Is Moving last resort
	return make_inaccurate_direction(player.last_known_velocity)
func make_inaccurate_direction(direction: Vector2) -> Vector2:
	if inaccuracy_stat == 0:
		return direction
	return GlobalStats.calculate_inaccurate_direction(direction, inaccuracy_stat)
func get_spawning_position() -> Vector2:
	var spawn_position = game_man.player.global_position + spread_offset
	return spawn_position
func get_spawning_duration() -> float:
	return super() + Statics.projectile_duration_buff
func get_spawn_parent() -> Node2D:
	return GameManager.instance.projectile_parent
func get_spawn_target() -> Node2D:
	var target: Node2D ## TODO: Setup proper ProjectileUpgrade Target Selection
	match target_selection:
		TargetSelectionTypes.Closest:
			target = get_nearest()
		TargetSelectionTypes.Farthest:
			target = get_nearest()
		TargetSelectionTypes.Random:
			target = get_nearest()
		TargetSelectionTypes.MostHp:
			target = get_nearest()
		TargetSelectionTypes.TowardsMouse:
			target = null
		TargetSelectionTypes.TowardsMovement:
			target = null
		TargetSelectionTypes.NoTarget:
			target = null
		_:
			target = get_nearest_enemy()
	return target
## Temporary method before i setup target selection properly
func get_nearest() -> Node2D:
	if infinite_range_stat:
		return get_nearest_enemy()
	return get_enemy_nearby(range_stat)
func get_attack_type() -> Attack.AttackTypes:
	return Attack.AttackTypes.projectile
